defmodule AdventOfCode.Day06 do
  def part1(input) do
    find_first_unique_of_size(input, 4)
  end

  def part2(input) do
    find_first_unique_of_size(input, 14)
  end

  def find_first_unique_of_size(input, size) do
    chunk_index =
      String.to_charlist(input)
      |> Enum.chunk_every(size, 1)
      |> Enum.find_index(fn chunk -> MapSet.new(chunk) |> MapSet.size() == size end)

    chunk_index + size
  end

  def parseInput(input) do
    String.trim(input)
  end
end
