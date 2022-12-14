defmodule AdventOfCode.Day14 do
  def part1(input) do
    IO.inspect(input)

    "dnf"
  end

  def part2(_input) do
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.map(&String.split(&1, ","))
    |> (fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end).()
  end
end
