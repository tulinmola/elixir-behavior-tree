defmodule Behavior.WaitNode do
  alias Behavior.WaitNode

  @type t :: %WaitNode{time: float}

  defstruct [:time]
end

defmodule Behavior.WaitTask do
  alias Behavior.WaitTask

  @type seconds :: float
  @type t :: %WaitTask{time: seconds}

  defstruct [:time]
end

defimpl Behavior.Node, for: Behavior.WaitNode do
  @spec create_task(Node.t()) :: Behavior.WaitTask.t()
  def create_task(node) do
    %Behavior.WaitTask{time: node.time}
  end
end

defimpl Behavior.Task, for: Behavior.WaitTask do
  alias Behavior.WaitTask

  @type t :: WaitTask.t()
  @type seconds :: float
  @type result :: :success | :running
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, dt) do
    if dt >= task.time do
      {:success, %WaitTask{time: 0}, state, dt - task.time}
    else
      {:running, %WaitTask{time: task.time - dt}, state, 0.0}
    end
  end
end
