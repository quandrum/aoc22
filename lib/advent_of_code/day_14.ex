defmodule AdventOfCode.Day14 do
  def parseInput(input) do
    String.trim(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      String.split(s, " -> ")
      |> Enum.map(fn s ->
        String.split(s, ",")
        |> Enum.map(&String.to_integer/1)
      end)
    end)
    |> Enum.reduce(%{}, fn row, map ->
      Enum.chunk_every(row, 2, 1)
      |> Enum.drop(-1)
      |> Enum.reduce(map, fn [[i, k], [j, l]], acc ->
        Enum.reduce(i..j, acc, fn x, ma ->
          Enum.reduce(k..l, ma, fn y, m ->
            Map.put(m, {x, y}, "#")
          end)
        end)
      end)
    end)
  end

  def part1(input) do
    maxy =
      Map.keys(input)
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort()
      |> Enum.at(-1)
      |> then(&(&1 + 1))

    fill_sand(input, maxy)
    |> Map.values()
    |> Enum.filter(&(&1 == "O"))
    |> Enum.count()
  end

  def part2(input) do
    maxy =
      Map.keys(input)
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort()
      |> Enum.at(-1)
      |> then(&(&1 + 2))

    Enum.reduce(300..700, input, fn x, acc -> Map.put(acc, {x, maxy}, "#") end)
    |> fill_sand(maxy + 1)
    |> print_board
    |> Map.values()
    |> Enum.filter(&(&1 == "O"))
    |> Enum.count()
  end

  defp print_board(board) do
    for y <- 0..163 do
      for x <- 375..725 do
        if Map.has_key?(board, {x, y}) do
          IO.write(Map.get(board, {x, y}))
        else
          IO.write(".")
        end
      end

      IO.write("\n")
    end

    board
  end

  @moves [{0, 1}, {-1, 1}, {1, 1}]
  @start {500, 0}

  defp fill_sand(input, maxy) do
    case drop_sand(input, @start, maxy) do
      {_, b} when b == maxy -> input
      {a, b} when a == 500 and b == 0 -> Map.put(input, {a, b}, "O")
      {a, b} -> fill_sand(Map.put(input, {a, b}, "O"), maxy)
    end
  end

  defp drop_sand(board, {x, y}, maxy) do
    case drop(board, {x, y}) do
      {a, b} when a == x and b == y -> {a, b}
      {a, b} when b == maxy -> {a, b}
      {a, b} -> drop_sand(board, {a, b}, maxy)
      _ -> {x, y}
    end
  end

  defp drop(board, {x, y}),
    do:
      Enum.map(@moves, fn {a, b} -> {a + x, b + y} end)
      |> Enum.find(fn move -> !Map.has_key?(board, move) end)
end
