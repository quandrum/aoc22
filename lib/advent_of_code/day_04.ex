defmodule AdventOfCode.Day04 do
  def part1(work_orders) do
    Enum.filter(work_orders, &is_complete_overlap?(&1))
    |> Enum.count()
  end

  def part2(work_orders) do
    Enum.filter(work_orders, &is_partial_overlap?(&1))
    |> Enum.count()
  end

  def is_complete_overlap?([a, b]), do: MapSet.subset?(a, b) || MapSet.subset?(b, a)
  def is_partial_overlap?([a, b]), do: !MapSet.disjoint?(a, b)

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&work_orders(&1))
  end

  def work_orders(work) do
    String.split(work, ",")
    |> (fn [first, second] -> [make_set(first), make_set(second)] end).()
  end

  def make_set(range) do
    String.split(range, "-")
    |> Enum.map(&String.to_integer(&1))
    |> (fn [x, y] -> Range.new(x, y) end).()
    |> MapSet.new()
  end
end
