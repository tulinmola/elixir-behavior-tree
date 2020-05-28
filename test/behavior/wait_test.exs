defmodule Behavior.WaitTest do
  use ExUnit.Case

  alias Behavior.{Node, Task, WaitNode, WaitTask}

  test "wait task" do
    task = Node.create_task(%WaitNode{time: 5})

    assert {:running, %WaitTask{time: 3}, %{}, 0.0} = Task.run(task, %{}, 2)
    assert {:success, %WaitTask{time: 0}, %{}, 0} = Task.run(task, %{}, 5)
    assert {:success, %WaitTask{time: 0}, %{}, 5} = Task.run(task, %{}, 10)
  end
end
