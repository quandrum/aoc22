defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> expand_moves
    |> move_n([{0, 0}, {0, 0}], MapSet.new())
  end

  def part2(input) do
    input
    |> expand_moves
    |> move_n(Range.new(1, 10) |> Enum.map(fn _ -> {0, 0} end), MapSet.new())
  end

  def expand_moves(moves) do
    Enum.flat_map(moves, fn [dir, count] ->
      Range.new(1, String.to_integer(count)) |> Enum.map(fn _ -> step(dir) end)
    end)
  end

  def move_n([], _rope, tail_pos), do: tail_pos

  def move_n([{dx, dy} | rest], [{hx, hy} | tails], tail_pos) do
    rope = Enum.scan([{hx + dx, hy + dy} | tails], fn t, h -> move_tail(h, t) end)
    move_n(rest, rope, MapSet.put(tail_pos, Enum.at(rope, -1)))
  end

  def move_tail({hx, hy}, {tx, ty}) do
    # IO.inspect("#{hx}, #{hy} - #{tx},#{ty}")
    case {hx - tx, hy - ty} do
      {2, 0} -> {tx + 1, ty}
      {0, 2} -> {tx, ty + 1}
      {-2, 0} -> {tx - 1, ty}
      {0, -2} -> {tx, ty - 1}
      {2, 1} -> {tx + 1, ty + 1}
      {2, -1} -> {tx + 1, ty - 1}
      {1, 2} -> {tx + 1, ty + 1}
      {-1, 2} -> {tx - 1, ty + 1}
      {-2, 1} -> {tx - 1, ty + 1}
      {-2, -1} -> {tx - 1, ty - 1}
      {1, -2} -> {tx + 1, ty - 1}
      {-1, -2} -> {tx - 1, ty - 1}
      {2, 2} -> {tx + 1, ty + 1}
      {2, -2} -> {tx + 1, ty - 1}
      {-2, 2} -> {tx - 1, ty + 1}
      {-2, -2} -> {tx - 1, ty - 1}
      _ -> {tx, ty}
    end
  end

  def step("R"), do: {1, 0}
  def step("L"), do: {-1, 0}
  def step("U"), do: {0, 1}
  def step("D"), do: {0, -1}

  def parseInput(input) do
    String.split(input, "\n")
    |> Enum.map(&String.split(&1, " "))
  end
end
