defmodule MC.Server do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, {}, opts)
  end

  @doc """
  Casts message to the server having it display the path to the goal.
  Also server stop itself to stop the task sup because of the one_for_one supvervision
  """
  def found_goal(path) do
    GenServer.cast(__MODULE__, {:goal, path})
  end

  ## Sever Callbacks
  def init(_args) do
    IO.puts "MC.Server has started"
     :ets.new(:duplicate_check, [:set, :public, :named_table, {:read_concurrency, true}])
    {:ok, %{}}
  end

  def handle_cast({:goal, path}, state) do
    IO.puts "Goal was reached"
    IO.inspect path
    {:stop, path, state}
  end

  def handle_info(:start, state) do
    MC.start_state
    {:noreply, state}
  end

end
