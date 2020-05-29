defmodule Behavior.CompositeNode do
  @spec __using__(atom) :: any
  defmacro __using__(_type) do
    quote do
      @type child :: any

      @type t :: %__MODULE__{
              children: [child]
            }

      defstruct children: []
    end
  end
end

defmodule Behavior.CompositeTask do
  @spec __using__(atom) :: any
  defmacro __using__(type) do
    %{module: task_module} = __CALLER__
    node_module = Module.concat(Behavior, Macro.camelize("#{type}Node"))

    quote do
      alias Behavior.Node

      @type child :: any
      @type task :: any

      @type t :: %__MODULE__{
              children: [child],
              current: task | nil
            }

      defstruct [:children, :current]

      defimpl Node, for: unquote(node_module) do
        alias Behavior.Node

        @spec create_task(Node.t()) :: any
        def create_task(node) do
          [first | rest] = node.children
          task = Node.create_task(first)
          %unquote(task_module){children: rest, current: task}
        end
      end
    end
  end
end
