defmodule AdventOfCode.Day05 do
  def part1([piers, moves]) do
    piers =
      Enum.reduce(moves, piers, fn {count, start, finish}, acc ->
        Enum.reduce(Range.new(1, String.to_integer(count)), acc, fn _n, inner ->
          {original, updated} =
            Map.get_and_update(inner, String.to_atom("#{start}"), fn cur ->
              {cur, Enum.drop(cur, -1)}
            end)

          {c, _l} = List.pop_at(original, -1)

          Map.update!(updated, String.to_atom("#{finish}"), fn cur -> cur ++ [c] end)
        end)
      end)

    Enum.reduce(Range.new(1, 9), [], fn n, acc ->
      acc ++ [get_last(String.to_atom("#{n}"), piers)]
    end)
  end

  def part2([piers, moves]) do
    piers =
      Enum.reduce(moves, piers, fn {count, start, finish}, acc ->
        IO.inspect(acc)

        {original, updated} =
          Map.get_and_update(acc, String.to_atom("#{start}"), fn cur ->
            {cur, Enum.drop(cur, -String.to_integer(count))}
          end)

        c = Enum.take(original, -String.to_integer(count))

        Map.update!(updated, String.to_atom("#{finish}"), fn cur -> cur ++ c end)
      end)

    Enum.reduce(Range.new(1, 9), [], fn n, acc ->
      acc ++ [get_last(String.to_atom("#{n}"), piers)]
    end)
  end

  def parseInput(input) do
    [pier, moves] = String.split(input, "\n\n")
    [parse_pier(String.split(pier, "\n")), parse_moves(String.trim(moves) |> String.split("\n"))]
  end

  def parse_pier(pier) do
    Enum.drop(pier, -1)
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn level, acc ->
      acc = add_crate(level, 1, acc)
      acc = add_crate(level, 2, acc)
      acc = add_crate(level, 3, acc)
      acc = add_crate(level, 4, acc)
      acc = add_crate(level, 5, acc)
      acc = add_crate(level, 6, acc)
      acc = add_crate(level, 7, acc)
      acc = add_crate(level, 8, acc)
      add_crate(level, 9, acc)
    end)
  end

  def add_crate(level, row, acc) do
    crate = String.at(level, (row - 1) * 4 + 1)

    if crate != " " do
      key = String.to_atom("#{row}")

      if Map.has_key?(acc, key) do
        elem(Map.get_and_update(acc, key, fn cur -> {cur, cur ++ [crate]} end), 1)
      else
        Map.put(acc, key, [crate])
      end
    else
      acc
    end
  end

  def parse_moves(moves), do: Enum.map(moves, &parse_move(&1))

  def parse_move(move) do
    String.split(move, " ")
    |> (fn move -> {Enum.at(move, 1), Enum.at(move, 3), Enum.at(move, 5)} end).()
  end

  def get_last(key, piers) do
    {crates, _piers} = Map.pop(piers, key)
    elem(List.pop_at(crates, -1), 0)
  end
end
