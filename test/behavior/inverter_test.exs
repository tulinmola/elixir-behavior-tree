defmodule Behavior.InverterTest do
  use BehaviorCase

  alias Behavior.{InverterNode, InverterTask}

  test "still running inverter" do
    child = %TestNode{result: :running, time: 10}
    task = Node.create_task(%InverterNode{child: child})

    assert {:running, %InverterTask{child: child}, %{}, 0} = Task.run(task, %{}, 5)
    assert child.time == 5
  end

  test "fails when child success" do
    child = %TestNode{result: :success, time: 10}
    task = Node.create_task(%InverterNode{child: child})

    assert {:failure, %InverterTask{}, %{}, 0} = Task.run(task, %{}, 10)
  end

  test "success when child fails" do
    child = %TestNode{result: :failure, time: 5}
    task = Node.create_task(%InverterNode{child: child})

    assert {:success, %InverterTask{}, %{}, 0} = Task.run(task, %{}, 10)
  end
end
