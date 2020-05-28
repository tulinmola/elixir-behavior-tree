defmodule Behavior.SelectorNode do
  use Behavior.CompositeNode, :selector
end

defmodule Behavior.SelectorTask do
  use Behavior.CompositeTask, :selector
end

defimpl Behavior.Task, for: Behavior.SelectorTask do
  alias Behavior.{Node, Task, SelectorTask}

  @type t :: SelectorTask.t()
  @type seconds :: float
  @type result :: :success | :running | :failure
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, dt) do
    case Task.run(task.current, state, dt) do
      {:failure, _current, state, rt} ->
        run_next(task, state, rt)

      {result, current, state, rt} ->
        {result, %SelectorTask{task | current: current}, state, rt}
    end
  end

  defp run_next(%{children: []} = task, state, dt) do
    {:failure, %SelectorTask{task | current: nil}, state, dt}
  end

  defp run_next(%{children: [first | rest]} = task, state, dt) do
    current = Node.create_task(first)
    task = %SelectorTask{task | current: current, children: rest}
    run(task, state, dt)
  end
end
