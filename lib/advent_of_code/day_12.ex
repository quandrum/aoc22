defmodule AdventOfCode.Day12 do
  def part1(input) do
    start = Map.get(input, "start")

    Map.get(input, start)
    |> bfs(input)

    "dnf"
  end

  def part2(_input) do
  end

  defp neighbors(graph, {x, y}) do
    [
      Map.get(graph, {x + 1, y}),
      Map.get(graph, {x, y + 1}),
      Map.get(graph, {x - 1, y}),
      Map.get(graph, {x, y - 1})
    ]
    |> Enum.filter(&is_nil/1)
  end

  defp bfs(current, graph), do: bfs([current], current, graph, MapSet.new([current]))

  defp bfs([node | rest], current, graph, visited) do
    if MapSet.member?(visited, node) do
      []
    else
      height = Map.get(graph, current)
      n = neighbors(graph, node)
    end

    #  case Map.get(graph, node) end
    #   "E" -> [node]
    #  n when n < curr -> [node | bfs([rest] ++  n, node)]
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, x}, acc ->
      Enum.with_index(row)
      |> Enum.reduce(acc, fn {val, y}, inner ->
        case val do
          "S" -> Map.put(inner, "start", {x, y})
          "E" -> Map.put(inner, "end", {x, y})
          _ -> inner
        end
        |> Map.put({x, y}, String.to_charlist(val) |> hd |> (fn c -> c - 97 end).())
      end)
    end)
  end
end
