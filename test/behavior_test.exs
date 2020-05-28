defmodule BehaviorTest do
  use ExUnit.Case
  doctest Behavior

  test "greets the world" do
    assert Behavior.hello() == :world
  end
end
