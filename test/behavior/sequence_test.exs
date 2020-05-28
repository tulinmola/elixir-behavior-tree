defmodule Behavior.SequenceTest do
  use BehaviorCase

  alias Behavior.{SequenceNode, SequenceTask}

  test "still running sequence" do
    child = %TestNode{result: :running, time: 10}
    task = Node.create_task(%SequenceNode{children: [child]})

    assert {:running, %SequenceTask{current: current}, %{}, 0} = Task.run(task, %{}, 5)
    assert current.time == 5
  end

  test "success when finishing sequence" do
    child = %TestNode{result: :success, time: 10}
    task = Node.create_task(%SequenceNode{children: [child]})

    assert {:success, %SequenceTask{current: nil}, %{}, 0} = Task.run(task, %{}, 10)
  end

  test "goes to next if task success" do
    first = %TestNode{result: :success, time: 5}
    second = %TestNode{result: :running, time: 10}
    task = Node.create_task(%SequenceNode{children: [first, second]})

    assert {:running, %SequenceTask{current: current}, %{}, 0} = Task.run(task, %{}, 10)
    assert current.result == :running
  end

  test "fails when task fails" do
    child = %TestNode{result: :failure, time: 10}
    task = Node.create_task(%SequenceNode{children: [child]})

    assert {:failure, %SequenceTask{current: current}, %{}, 0} = Task.run(task, %{}, 5)
    assert current.time == 5
  end
end
