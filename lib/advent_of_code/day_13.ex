defmodule AdventOfCode.Day13 do
  def part1(input) do
    IO.inspect(input)

    "dnf"
  end

  def part2(input) do
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn [fst, snd] -> {parse(fst), parse(snd)} end)
  end

  def parse(""), do: []
  def parse("[" <> rest), do: [parse(rest)]
  def parse("]" <> rest), do: parse(rest)

  def parse(input) do
    {fst, rest} = String.split_at(input, 1)

    case Integer.parse(fst) do
      {n, ""} -> [n | parse(rest)]
      _ -> parse(rest)
    end
  end
end
