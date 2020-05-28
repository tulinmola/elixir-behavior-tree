defmodule Behavior.ConditionalNode do
  alias Behavior.ConditionalNode

  @type behavior :: any
  @type t :: %ConditionalNode{condition: function, child: behavior}

  defstruct [:condition, :child]
end

defmodule Behavior.ConditionalTask do
  alias Behavior.ConditionalTask

  @type task :: any
  @type t :: %ConditionalTask{condition: function, child: task}

  defstruct [:condition, :child]
end

defimpl Behavior.Node, for: Behavior.ConditionalNode do
  alias Behavior.{ConditionalTask, Node}

  @spec create_task(Node.t()) :: ConditionalTask.t()
  def create_task(node) do
    child = Node.create_task(node.child)
    %Behavior.ConditionalTask{condition: node.condition, child: child}
  end
end

defimpl Behavior.Task, for: Behavior.ConditionalTask do
  alias Behavior.{Task, ConditionalTask}

  @type t :: ConditionalTask.t()
  @type seconds :: float
  @type result :: :success | :running | :failure
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, dt) do
    if task.condition.(state) do
      Task.run(task.child, state, dt)
    else
      {:failure, task, state, dt}
    end
  end
end
