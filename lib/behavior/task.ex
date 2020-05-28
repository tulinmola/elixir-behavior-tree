defprotocol Behavior.Task do
  @type seconds :: float
  @type result :: :success | :running | :failure
  @type state :: map

  @spec run(t, state, seconds) :: {result, t, state, seconds}
  def run(task, state, time)
end

defmodule Behavior.TaskFactory do
  alias Behavior.Node

  @spec create(any) :: any
  def create(node) do
    Node.create_task(node)
  end
end
