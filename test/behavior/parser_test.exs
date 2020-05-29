defmodule Behavior.ParserTest do
  use ExUnit.Case

  alias Behavior.Parser

  defmodule(CompositeNode, do: defstruct([:children]))
  defmodule(DecoratorNode, do: defstruct([:child]))
  defmodule(ActionNode, do: defstruct([:message]))

  test "greets the world" do
    content = """
    {
      "node": "composite",
      "children": [
        {
          "node": "action",
          "message": "first"
        },
        {
          "node": "decorator",
          "child": {
            "node": "action",
            "message": "second"
          }
        }
      ]
    }
    """

    assert %CompositeNode{
             children: [
               %ActionNode{message: "first"},
               %DecoratorNode{
                 child: %ActionNode{message: "second"}
               }
             ]
           } = Parser.parse(content)
  end
end
