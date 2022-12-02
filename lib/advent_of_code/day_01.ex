defmodule AdventOfCode.Day01 do
  def part1(input) do
    Enum.map(input, &elfWeight(&1))
    |> Enum.sort()
    |> Enum.at(-1)
  end

  def part2(input) do
    Enum.map(input, &elfWeight(&1))
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n\n")
  end

  def elfWeight(elf) do
    String.split(elf, "\n")
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sum()
  end
end
