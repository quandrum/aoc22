defmodule AdventOfCode.Day02 do
  def part1(input) do
    Enum.map(input, &playHand(&1))
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sum()
  end

  def part2(input) do
    Enum.map(input, &playResult(&1))
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sum()
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
  end

  def playHand(guide) do
    String.split(guide, " ")
    |> (fn [a, b] -> [convert(a), convert(b)] end).()
    |> (fn [a, b] -> [result(a, b), score(b)] end).()
  end

  def playResult(guide) do
    String.split(guide, " ")
    |> (fn [a, b] -> [convert(a), findDesiredResult(b)] end).()
    |> (fn [a, b] -> [a, myThrow(a, b)] end).()
    |> (fn [a, b] -> [result(a, b), score(b)] end).()
  end

  def convert("A"), do: :rock
  def convert("B"), do: :paper
  def convert("C"), do: :scissors
  def convert("X"), do: :rock
  def convert("Y"), do: :paper
  def convert("Z"), do: :scissors

  def findDesiredResult("X"), do: :lose
  def findDesiredResult("Y"), do: :draw
  def findDesiredResult("Z"), do: :win

  def result(:rock, :rock), do: 3
  def result(:rock, :paper), do: 6
  def result(:rock, :scissors), do: 0
  def result(:paper, :paper), do: 3
  def result(:paper, :scissors), do: 6
  def result(:paper, :rock), do: 0
  def result(:scissors, :scissors), do: 3
  def result(:scissors, :rock), do: 6
  def result(:scissors, :paper), do: 0

  def score(:rock), do: 1
  def score(:paper), do: 2
  def score(:scissors), do: 3

  def myThrow(:rock, :win), do: :paper
  def myThrow(:rock, :draw), do: :rock
  def myThrow(:rock, :lose), do: :scissors
  def myThrow(:paper, :win), do: :scissors
  def myThrow(:paper, :draw), do: :paper
  def myThrow(:paper, :lose), do: :rock
  def myThrow(:scissors, :win), do: :rock
  def myThrow(:scissors, :draw), do: :scissors
  def myThrow(:scissors, :lose), do: :paper
end
