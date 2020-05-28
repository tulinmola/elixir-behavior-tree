defmodule Behavior.InverterNode do
  use Behavior.DecoratorNode, :inverter
end

defmodule Behavior.InverterTask do
  use Behavior.DecoratorTask, :inverter
end

defimpl Behavior.Task, for: Behavior.InverterTask do
  alias Behavior.{Task, InverterTask}

  @type t :: InverterTask.t()
  @type seconds :: float
  @type result :: :success | :running | :failure
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, dt) do
    {result, child, state, rt} = Task.run(task.child, state, dt)
    {invert(result), %InverterTask{task | child: child}, state, rt}
  end

  defp invert(:success), do: :failure

  defp invert(:failure), do: :success

  defp invert(result), do: result
end
