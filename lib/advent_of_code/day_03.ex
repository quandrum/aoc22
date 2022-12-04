defmodule AdventOfCode.Day03 do
  def part1(suitcases) do
    Enum.map(suitcases, &split(&1))
    |> Enum.map(&(fn [a, b] -> MapSet.intersection(a, b) end).(&1))
    |> Enum.map(&MapSet.to_list(&1))
    |> List.flatten()
    |> Enum.map(&to_priority(&1))
    |> Enum.sum()
  end

  def part2(suitcases) do
    Enum.map(suitcases, &to_charlist(&1))
    |> Enum.map(&MapSet.new(&1))
    |> find_badges
    |> Enum.sum()
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
  end

  def split(suitcase) do
    String.split_at(suitcase, div(String.length(suitcase), 2))
    |> (fn {a, b} -> [MapSet.new(to_charlist(a)), MapSet.new(to_charlist(b))] end).()
  end

  def find_badges([]), do: []
  def find_badges([_fst]), do: []
  def find_badges([_fst, _snd]), do: []
  def find_badges([fst, snd, thd | rest]) do
    badge =
      MapSet.intersection(fst, snd)
      |> MapSet.intersection(thd)
      |> MapSet.to_list()
      |> hd
      |> to_priority

    [badge | List.flatten(find_badges(rest))]
  end

  def to_priority(char) do
    case char do
      x when x in 65..90 -> char - 38
      x when x in 97..122 -> char - 96
      _ -> IO.inspect(char)
    end
  end
end
