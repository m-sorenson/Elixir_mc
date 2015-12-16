defmodule MC.Server do
  use GenServer

  @table_name :duplicate_check

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, {}, opts)
  end

  @doc """
  Casts message to the server having it display the path to the goal.
  Also server stop itself to stop the task sup because of the one_for_all supvervision
  """
  def found_goal(path) do
    GenServer.cast(__MODULE__, {:goal, path})
  end

  def monitor_task(path) do
    GenServer.cast(__MODULE__, {:new_task, path})
  end

  @doc """
  Takes the full path and pretty prints the solution.
  """
  def pretty_print([]) do
    IO.puts "Initial state"
  end

  def pretty_print([{-1, m, c} | tail]) do
    pretty_print(tail)
    IO.puts "[ Far,  m = #{m}, c = #{c} ]"
  end

  def pretty_print([{1, m, c} | tail]) do
    pretty_print(tail)
    IO.puts "[ Near, m = #{m}, c = #{c} ]"
  end

  ## Sever Callbacks
  def init(_args) do
    IO.puts "MC.Server has started"
     @table_name = :ets.new(@table_name, [:set, :public, :named_table, {:read_concurrency, true}])
    {:ok, %{:crash => 0, :total => 0}}
  end

  def handle_cast({:new_task, path}, state) do
    {:ok, pid} = MC.create_worker(path)
    Process.monitor(pid)
    {:noreply, state}
  end

  def handle_cast({:goal, path}, state) do
    pretty_print(path)
    IO.puts "Goal state"
    IO.inspect state
    {:stop, path, state}
  end

  def handle_info(:start, state) do
    {:ok, _pid} = MC.start_state
    {:noreply, state}
  end

  def handle_info({:DOWN, _, _, _, :normal}, state = %{:total => total}) do
    {:noreply, %{state | :total => total + 1}}
  end

  def handle_info(_anything, state = %{:crash => crash, :total => total}) do
    {:noreply, %{state | :crash => crash + 1, :total => total + 1}}
  end

end
