defmodule Behavior.SequenceNode do
  use Behavior.CompositeNode, :sequence
end

defmodule Behavior.SequenceTask do
  use Behavior.CompositeTask, :sequence
end

defimpl Behavior.Task, for: Behavior.SequenceTask do
  alias Behavior.{Node, Task, SequenceTask}

  @type t :: SequenceTask.t()
  @type seconds :: float
  @type result :: :success | :running | :failure
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, dt) do
    case Task.run(task.current, state, dt) do
      {:success, _current, state, rt} ->
        run_next(task, state, rt)

      {result, current, state, rt} ->
        {result, %SequenceTask{task | current: current}, state, rt}
    end
  end

  defp run_next(%{children: []} = task, state, dt) do
    {:success, %SequenceTask{task | current: nil}, state, dt}
  end

  defp run_next(%{children: [first | rest]} = task, state, dt) do
    current = Node.create_task(first)
    task = %SequenceTask{task | current: current, children: rest}
    run(task, state, dt)
  end
end
