defmodule AdventOfCode.Day15 do
  def part1(input) do
    minx = input |> Enum.map(fn {{x, _}, _, d} -> x - d end) |> Enum.sort() |> Enum.at(0)
    maxx = input |> Enum.map(fn {{x, _}, _, d} -> x + d end) |> Enum.sort() |> Enum.at(-1)
    beacons = input |> Enum.reduce(MapSet.new(), fn {_, b, _}, acc -> MapSet.put(acc, b) end)

    Enum.filter(Range.new(minx, maxx), &in_signal_range?(&1, 2_000_000, input, beacons))
    |> Enum.count()
  end

  defp in_signal_range?(_, _, [], _), do: false

  defp in_signal_range?(x, y, [{{a, b}, _, dist} | tail], beacons) do
    if !MapSet.member?(beacons, {x, y}) && man_dist({{x, y}, {a, b}}) <= dist do
      true
    else
      in_signal_range?(x, y, tail, beacons)
    end
  end

  def part2(input) do
    Enum.reduce(input, nil, fn signal, beacon ->
      if !is_nil(beacon) do
        beacon
      else
        get_edges(signal)
        |> Enum.find(fn {x, y} -> !in_signal_range?(x, y, input, MapSet.new()) end)
      end
    end)
    |> then(fn {x, y} -> x * 4_000_000 + y end)
  end

  def get_edges({{x, y}, _, dist}) do
    edge = dist + 1

    edges =
      get_edge({x - edge, y}, dist, {1, -1}) ++
        get_edge({x, y - edge}, dist, {1, 1}) ++
        get_edge({x + edge, y}, dist, {-1, 1}) ++
        get_edge({x, y + edge}, dist, {-1, -1})

    Enum.filter(edges, fn {x, y} -> x >= 0 && y >= 0 && x <= 4_000_000 && y <= 4_000_000 end)
  end

  def get_edge({x, y}, dist, {dx, dy}) do
    Enum.map(0..dist, fn d -> {x + d * dx, y + d * dy} end)
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(
      &Regex.named_captures(
        ~r/Sensor at x=(?<x>\d+), y=(?<y>\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/,
        &1
      )
    )
    |> Enum.map(fn %{"x" => x, "y" => y, "bx" => bx, "by" => by} ->
      {{String.to_integer(x), String.to_integer(y)},
       {String.to_integer(bx), String.to_integer(by)}}
    end)
    |> Enum.map(fn {{x, y}, {bx, by}} -> {{x, y}, {bx, by}, man_dist({{x, y}, {bx, by}})} end)
  end

  defp man_dist({{x, y}, {bx, by}}), do: abs(x - bx) + abs(y - by)
end
