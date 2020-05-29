defmodule Behavior.DecoratorNode do
  @spec __using__(atom) :: any
  defmacro __using__(_type) do
    quote do
      @type child :: any

      @type t :: %__MODULE__{
              child: child
            }

      defstruct [:child]
    end
  end
end

defmodule Behavior.DecoratorTask do
  @spec __using__(atom) :: any
  defmacro __using__(type) do
    %{module: task_module} = __CALLER__
    node_module = Module.concat(Behavior, Macro.camelize("#{type}Node"))

    quote do
      alias Behavior.Node

      @type task :: any

      @type t :: %__MODULE__{
              child: task
            }

      defstruct [:child]

      defimpl Node, for: unquote(node_module) do
        alias Behavior.Node

        @spec create_task(Node.t()) :: any
        def create_task(node) do
          task = Node.create_task(node.child)
          %unquote(task_module){child: task}
        end
      end
    end
  end
end
