defmodule AdventOfCode.Day04 do
  def part1(work_orders) do
    Enum.filter(work_orders, &is_complete_overlap(&1))
    |> Enum.count()
  end

  def part2(work_orders) do
    Enum.filter(work_orders, &is_partial_overlap(&1))
    |> Enum.count()
  end

  def parseInput(input) do
    String.trim(input) 
    |> String.split("\n")
    |> Enum.map(&work_orders(&1))
  end

  def work_orders(work) do
    [first, second] = String.split(work, ",")

    [
      Enum.map(String.split(first, "-"), &String.to_integer(&1)),
      Enum.map(String.split(second, "-"), &String.to_integer(&1))
    ]
  end

  def is_complete_overlap([[a, b], [x, y]]) do
    (a <= x && b >= y) || (x <= a && y >= b)
  end

  def is_partial_overlap([[a, b], [x, y]]) do
    is_complete_overlap([[a,b], [x,y]]) || (x >= a && x <= b) || (y >= a && y <= b)
  end
end
