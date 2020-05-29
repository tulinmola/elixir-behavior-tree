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

## Add Custom Nodes and Tasks

What's the joy of having only structural behavior trees? Here it is
an example of custom `move_to` node with its task.

Supposing this json configuration:

```json
{
  "node": "move_to",
  "target": [1, 2]
}
```

This is what is needed:

```elixir
defmodule MyApp.Behavior.MoveToNode do
  # Tree node definition. As seen in json file target
  # is a list of two elements (x and y coordinates).
  defstruct [:target]
end

defmodule MyApp.Behavior.MoveToTask do
  # The task is the instance of a node. In this case
  # this target is a proper parsed Vector struct. Here
  # you can add all the parameters you need for your
  # task. They can vary a lot from node's one or be
  # almost the same (as seen here).
  defstruct [:target]
end

defimpl Behavior.Node, for: MyApp.Behavior.MoveToNode do
  # Given a node this is the task factory for it. This
  # is where all task parameters are initialized.
  def create_task(node) do
    vector = Vector.parse(node.target)
    %MyApp.Behavior.MoveToTask{target: vector}
  end
end

defimpl Behavior.Task, for: MyApp.Behavior.MoveToTask do
  @velocity 3

  # Running tasks require the task to run, a state and elapsed
  # time. The response is the status of the task --:success,
  # :running and :failure--, the updated task, the updated state
  # and the remaining time (this is useful for executing various
  # tasks in the same elapsed time).
  def run(task, state, dt) do
    vector = Vector.sub(task.target, state.position)
    distance = Vector.length(vector)
    movement = @velocity * dt

    if distance <= movement do
      # If target is reached, we have remaining time and the
      # new position is the target.

      remaining_time = (movement - distance) * dt / movement
      {:success, task, %{state | position: task.target}, remaining_time}
    else
      # If not, update state position with 0 remaining time.

      new_position =
        vector
        |> Vector.scale(movement / distance)
        |> Vector.add(state.position)

      {:running, task, %{state | position: new_position}, 0.0}
    end
  end
end
```

Taking care in configuration to add custom base module:

```elixir
config :behavior, Behavior.Parser,
  base_modules: [MyApp.Behavior]
```

## Commit guidelines

Having a good guideline for creating commits and sticking to it makes working
with Git and collaborating with others a lot easier. Please, follow these simple
wide used recommended rules:

- Always use english language.
- Separate subject from body with a blank line.
- Limit the subject line to 50 characters.
- Capitalize the subject line.
- Do not end the subject line with a period.
- Use the imperative mood in the subject line, that is as if you were
commanding someone. Start the line with "Fix", "Add", "Change" instead
of "~~Fixed~~", "~~Added~~", "~~Changed~~".
- Wrap the body at 72 characters.

Here is the classic long commit example:

> ```
> Short (50 chars or less) summary of changes
>
> More detailed explanatory text, if necessary.  Wrap it to about 72
> characters or so.  In some contexts, the first line is treated as the
> subject of an email and the rest of the text as the body.  The blank
> line separating the summary from the body is critical (unless you omit
> the body entirely); tools like rebase can get confused if you run the
> two together.
>
> Further paragraphs come after blank lines.
>
>   - Bullet points are okay, too
>
>   - Typically a hyphen or asterisk is used for the bullet, preceded by a
>     single space, with blank lines in between, but conventions vary here
> ```

### References

* https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project
* https://chris.beams.io/posts/git-commit/
* https://github.com/erlang/otp/wiki/writing-good-commit-messages
