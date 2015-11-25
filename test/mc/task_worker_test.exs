defmodule MC.TaskWorkerTest do
  use ExUnit.Case

  test "invalid states tests" do
    assert false == MC.TaskWorker.valid?({1, 2, 3})
    assert false == MC.TaskWorker.valid?({1, 1, 3})
    assert false == MC.TaskWorker.valid?({1, -1, 3})
    assert false == MC.TaskWorker.valid?({1, 7, 3})
    assert false == MC.TaskWorker.valid?({1, 7, 0})
    assert false == MC.TaskWorker.valid?({1, -7, 0})
    assert false == MC.TaskWorker.valid?({1, 7, 7})
    assert false == MC.TaskWorker.valid?({1, 1, 2})
  end

  test "valid states tests" do
    assert true == MC.TaskWorker.valid?({1, 3, 3})
    assert true == MC.TaskWorker.valid?({1, 2, 2})
    assert true == MC.TaskWorker.valid?({1, 1, 1})
    assert true == MC.TaskWorker.valid?({1, 0, 0})
    assert true == MC.TaskWorker.valid?({1, 3, 0})
    assert true == MC.TaskWorker.valid?({1, 3, 3})
    assert true == MC.TaskWorker.valid?({1, 3, 1})
    assert true == MC.TaskWorker.valid?({1, 3, 2})
    assert true == MC.TaskWorker.valid?({1, 0, 2})
    assert true == MC.TaskWorker.valid?({1, 0, 1})
  end

  test "not goal states" do
    assert false == MC.TaskWorker.goal?({1, 3, 3})
    assert false == MC.TaskWorker.goal?({1, 0, 0})
    assert false == MC.TaskWorker.goal?({-1, 3, 3})
    assert false == MC.TaskWorker.goal?({-1, 1, 2})
    assert false == MC.TaskWorker.goal?({-1, 0, 1})
  end

  test "found goal" do
    assert true == MC.TaskWorker.goal?({-1, 0, 0})
  end
end
