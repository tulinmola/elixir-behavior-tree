defmodule Behavior do
  alias Behavior.{Node, Parser, Task}

  @type tree :: any
  @type task :: any
  @type seconds :: float
  @type task_status :: :success | :running | :failure
  @type state :: map
  @type task_result :: {task_status, task, state, seconds}

  @spec parse!(binary) :: tree
  def parse!(filename) do
    filename
    |> File.read!()
    |> Parser.parse()
  end

  @spec create_task(tree) :: task
  def create_task(root) do
    Node.create_task(root)
  end

  @spec run_task(task, state, seconds) :: task_result
  def run_task(task, state, dt) do
    Task.run(task, state, dt)
  end
end
