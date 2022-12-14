defmodule AdventOfCode.Day10 do
  def cycles(input) do
    parse_input(input)
    |> Enum.scan(1, &(&1 + &2))
    |> then(&[1 | &1])
  end

  def part1(input) do
    cycles(input)
    |> Enum.with_index(1)
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.map(fn {i, n} -> i * n end)
    |> Enum.sum()
  end

  def part2(input) do
    cycles(input)
    |> Enum.with_index()
    |> Enum.map(fn {i, n} -> abs(i - rem(n, 40)) <= 1 end)
    |> Enum.flat_map(fn pixel ->
      case pixel do
        true -> ["#"]
        false -> ["."]
      end
    end)
    |> Enum.chunk_every(40)
    |> Enum.join("\n")
  end

  def parseInput(input) do
    String.split(input, "\n")
    |> Enum.flat_map(&to_cmd(&1))
  end

  def to_cmd("noop"), do: [0]
  def to_cmd("addx " <> x), do: [0, String.to_integer(x)]
end
