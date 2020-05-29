defmodule Behavior.Parser do
  require Logger

  @config Application.get_env(:behavior, Behavior.Parser)
  @base_modules @config[:base_modules] ++ [Behavior]

  @spec parse(binary) :: any
  def parse(content) do
    content
    |> Jason.decode!()
    |> do_parse()
  end

  defp do_parse(%{"node" => type} = data) do
    module = find_node_module(type)

    fields =
      module.__struct__
      |> Map.keys()
      |> Enum.reduce([], &reducer(data, &1, &2))
      |> Map.new()

    check_fields(data, fields)

    struct!(module, fields)
  end

  defp find_node_module(type) do
    name =
      "#{type}Node"
      |> String.split(".")
      |> Enum.map(&Macro.camelize/1)
      |> Enum.join(".")

    @base_modules
    |> Enum.find(fn base ->
      module = Module.concat(base, name)
      Code.ensure_compiled?(module)
    end)
    |> case do
      nil -> raise "Couln't find module #{name}"
      base -> Module.concat(base, name)
    end
  end

  defp reducer(%{"children" => children}, :children, fields) do
    [{:children, Enum.map(children, &do_parse/1)} | fields]
  end

  defp reducer(%{"child" => child}, :child, fields) do
    [{:child, do_parse(child)} | fields]
  end

  defp reducer(data, key, fields) do
    case Map.get(data, to_string(key)) do
      nil -> fields
      value -> [{key, value} | fields]
    end
  end

  defp check_fields(data, fields) do
    data_keys =
      data
      |> Map.delete("node")
      |> Map.keys()
      |> MapSet.new()

    field_keys =
      fields
      |> Map.keys()
      |> Enum.map(&to_string/1)
      |> MapSet.new()

    data_keys
    |> MapSet.difference(field_keys)
    |> Enum.each(fn key ->
      Logger.warn("Behaviour.Parser Ignoring key: \"#{key}\"")
    end)
  end
end
