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
    opts = [strategy: :one_for_one, name: MC.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def create_worker(state) do
    Task.Supervisor.start_child(@task_sup, fn -> MC.TaskWorker.start(state) end)
  end

  def start_state() do
    create_worker([{1, 3, 3}])
  end
end
