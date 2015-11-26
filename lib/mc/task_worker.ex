defmodule MC.TaskWorker do

  def start(state = [h|t]) do
    IO.puts "State is "
    IO.inspect state
    IO.puts "Head of list is "
    IO.inspect h
    IO.puts "Tail of list is "
    IO.inspect t
  end

  def valid?(_) do
    false
  end

  def goal?(_) do
    false
  end

  def duplicate?(state) do
    key = state_key(state)
     ! :ets.insert_new(:duplicate_check, {key, state})
  end

  def state_key({ boat, m, c }) do
    to_string(boat) <> to_string(m) <> to_string(c)
  end

end
