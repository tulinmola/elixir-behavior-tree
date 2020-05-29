# Elixir Behavior Tree

Very specific behavior tree Elixir implementation.

## Installation

The package can be installed by adding `behavior` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [{:behavior, git: "https://github.com/tulinmola/elixir-behavior-tree"}]
end
```

## Configuration

To add custom nodes, just add parent module to config, so parser can find them:

```elixir
config :behavior, Behavior.Parser,
  base_modules: [App.Behavior, App2.BehaviorTree]
```

## Use Example

```json
{
  "node": "selector",
  "children": [
    {
      "node": "sequence",
      "children": [
        {
          "node": "log",
          "message": "I will succeed passing to the next sequence children"
        },
        {
          "node": "inverter",
          "child": {
            "node": "log",
            "message": "I will fail due to inverter, making this sequence fail"
          }
        }
      ]
    },
    {
      "node": "log",
      "message": "I will make selector succeed!"
    }
  ]
}
```

Parse with:

```elixir
> root = Behavior.parse!("filename.json")
```

Creating task:

```elixir
> task = Behavior.create_task(root)
%Behavior.SelectorTask{...}
```

And running:

```elixir
> Behavior.run_task(task, %{foo: "bar"}, 1.5)
{:success, %Behavior.SelectorTask{...}, %{foo: "bar}, 1.5}
```
