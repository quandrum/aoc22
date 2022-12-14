defmodule AdventOfCode.Day08 do
  def part1({{maxx, maxy}, map}) do
    Enum.flat_map(Range.new(0, maxx - 1), fn x ->
      Enum.map(Range.new(0, maxy - 1), fn y ->
        {{x, y}, is_visible?({x, y}, map)}
      end)
    end)
    |> Enum.filter(fn {_pos, vis} -> vis end)
    |> length
  end

  defp is_visible?({x, y}, map) do
    if !Map.has_key?(map, {x, y}) do
      false
    else
      get_values({x, y}, {-1, 0}, map) |> is_tree_visible? ||
        get_values({x, y}, {0, -1}, map) |> is_tree_visible? ||
        get_values({x, y}, {1, 0}, map) |> is_tree_visible? ||
        get_values({x, y}, {0, 1}, map) |> is_tree_visible?
    end
  end

  defp get_values({x, y}, {dx, dy}, map) do
    if !Map.has_key?(map, {x, y}) do
      []
    else
      [Map.get(map, {x, y}) | get_values({x + dx, y + dy}, {dx, dy}, map)]
    end
  end

  defp is_tree_visible?([_n]), do: true

  defp is_tree_visible?([tree | rest]) do
    Enum.all?(rest, fn n -> n < tree end)
  end

  def part2({{maxx, maxy}, map}) do
    Enum.flat_map(Range.new(1, maxx - 2), fn x ->
      Enum.map(Range.new(1, maxy - 2), fn y ->
        get_viewing_score({x, y}, map)
      end)
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> hd
  end

  defp get_viewing_score({x, y}, map) do
    if !Map.has_key?(map, {x, y}) do
      0
    else
      (get_values({x, y}, {-1, 0}, map) |> viewing_score_count) *
        (get_values({x, y}, {0, -1}, map) |> viewing_score_count) *
        (get_values({x, y}, {1, 0}, map) |> viewing_score_count) *
        (get_values({x, y}, {0, 1}, map) |> viewing_score_count)
    end
  end

  defp viewing_score_count([_tree]), do: 1

  defp viewing_score_count([curr | rest]) do
    case Enum.find_index(rest, fn t -> t >= curr end) do
      nil -> length(rest)
      idx -> idx + 1
    end
  end

  def parseInput(input) do
    grid =
      String.split(input, "\n")
      |> Enum.map(&String.graphemes(&1))
      |> Enum.map(fn x -> Enum.map(x, fn y -> String.to_integer(y) end) end)

    range = {length(grid), length(hd(grid))}

    map =
      grid
      |> Enum.map(&Enum.with_index(&1))
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, idy} ->
        Enum.map(row, fn {val, idx} -> {{idx, idy}, val} end)
      end)
      |> Map.new()

    {range, map}
  end
end
