defmodule MC.Server do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, {}, opts)
  end

  def found_goal(path) do
    GenServer.cast(__MODULE__, {:goal, path})
  end

  ## Sever Callbacks
  def init(_args) do
    IO.puts "MC.Server has started"
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
