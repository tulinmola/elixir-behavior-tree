defmodule BehaviorCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Behavior.{Node, Task, SelectorNode, SelectorTask}

      defmodule(TestNode, do: defstruct([:result, :time]))

      defmodule(TestTask, do: defstruct([:result, :time]))

      defimpl Node, for: TestNode do
        def create_task(node) do
          %TestTask{result: node.result, time: node.time}
        end
      end

      defimpl Task, for: TestTask do
        def run(task, state, dt) do
          {task.result, %TestTask{task | time: task.time - dt}, state, 0}
        end
      end
    end
  end

  setup _tags do
    :ok
  end
end
