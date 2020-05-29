defmodule Behavior.LogNode do
  alias Behavior.LogNode

  @type t :: %LogNode{message: binary}
  defstruct [:message]
end

defmodule Behavior.LogTask do
  alias Behavior.LogTask

  @type t :: %LogTask{message: binary}
  defstruct [:message]
end

defimpl Behavior.Node, for: Behavior.LogNode do
  @spec create_task(Node.t()) :: Behavior.LogTask.t()
  def create_task(node) do
    %Behavior.LogTask{message: node.message}
  end
end

defimpl Behavior.Task, for: Behavior.LogTask do
  alias Behavior.LogTask

  require Logger

  @type t :: LogTask.t()
  @type seconds :: float
  @type result :: :success
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, dt) do
    Logger.info(task.message)
    {:success, task, state, dt}
  end
end
