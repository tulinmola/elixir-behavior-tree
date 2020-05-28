defmodule Behavior.SelectorTest do
  use BehaviorCase

  alias Behavior.{SelectorNode, SelectorTask}

  test "still running selector" do
    child = %TestNode{result: :running, time: 10}
    task = Node.create_task(%SelectorNode{children: [child]})

    assert {:running, %SelectorTask{current: current}, %{}, 0} = Task.run(task, %{}, 5)
    assert current.time == 5
  end

  test "sucess when any task sucess" do
    child = %TestNode{result: :success, time: 5}
    task = Node.create_task(%SelectorNode{children: [child]})

    assert {:success, %SelectorTask{}, %{}, 0} = Task.run(task, %{}, 10)
  end

  test "fails when finishing selector" do
    child = %TestNode{result: :failure, time: 10}
    task = Node.create_task(%SelectorNode{children: [child]})

    assert {:failure, %SelectorTask{current: nil}, %{}, 0} = Task.run(task, %{}, 10)
  end

  test "goes to next if task fails" do
    first = %TestNode{result: :failure, time: 5}
    second = %TestNode{result: :running, time: 10}
    task = Node.create_task(%SelectorNode{children: [first, second]})

    assert {:running, %SelectorTask{current: current}, %{}, 0} = Task.run(task, %{}, 10)
    assert current.result == :running
  end
end
