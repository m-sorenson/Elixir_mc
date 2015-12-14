defmodule MC.TaskWorker do

  @doc """
  Takes the full path as a parameter. Uses helper functions to continue the search
  to the goal.
  """
  def start(path = [state | _tail]) do
    false = goal?(path)
    true = valid?(state)
    false = duplicate?(state)

    next_states(state) |>
    Enum.map(fn next_state -> [ next_state | path ] end) |>
    Enum.each(fn next_path -> MC.create_worker(next_path) end)
  end

  @doc """
  Takes a state and returns a boolean declaring if the state is valid.
  """
  def valid?(state = {_, m, c}) do
    if safe?(state) and m >= 0 and m <= 3 and c >= 0 and c <= 3 do
      true
    else
      false
    end
  end

  @doc """
  Takes a state and returns a boolean declaring if the state is safe.
  """
  def safe?({_, m, c}) do
    if m == 0 or m == 3 or m == c do
      true
    else
      false
    end
  end

  @doc """
  Tests if state is goal
  """
  def goal?(path = [{-1, 0, 0} | _t]) do
    MC.Server.found_goal(path)
    true
  end

  def goal?(_) do
    false
  end

  @doc """
  Checks if a state has already been used. Adds it to the public ets if it is new
  Returns boolean declaring if it has been perviously used.
  """
  def duplicate?(state) do
    key = state_key(state)
     ! :ets.insert_new(:duplicate_check, {key, state})
  end

  @doc """
  Takes a state tuple and converts it into a unique string.
  """
  def state_key({ boat, m, c }) do
    to_string(boat) <> to_string(m) <> to_string(c)
  end

  @doc """
  Takes current state and computes next states.
  """
  def next_states({b, m, c}) do
    next_b = b * -1
    [ {next_b, m + 2 * next_b, c},
      {next_b, m, c + 2 * next_b},
      {next_b, m + 1 * next_b, c + 1 * next_b},
      {next_b, m + 1 * next_b, c},
      {next_b, m, c + 1 * next_b} ]
  end

end
