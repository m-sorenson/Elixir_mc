defmodule MC do
  use Application

  @server_name MC.Server
  @task_sup MC.TaskSup

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(MC.Worker, [arg1, arg2, arg3]),
      supervisor(Task.Supervisor, [[name: @task_sup]]),
      worker(MC.Server, [[name: @server_name]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: MC.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Takes a path of states creates a new task to continue searching for solution.
  """
  def create_worker(path) do
    Task.Supervisor.start_child(@task_sup, fn -> MC.TaskWorker.start(path) end)
  end

  @doc """
  Starts search by creating a task with the default start state.
  """
  def start_state() do
    create_worker([{1, 3, 3}])
  end
end
