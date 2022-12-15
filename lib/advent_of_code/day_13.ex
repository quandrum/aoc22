defmodule AdventOfCode.Day13 do
  def part1(input) do
    Enum.map(input, &compare?/1)
    |> Enum.with_index()
    |> Enum.filter(&elem(&1, 0))
    |> Enum.map(fn {_, idx} -> idx + 1 end)
    |> Enum.sum()
  end

  def part2(input) do
    sorted =
      Enum.flat_map(input, fn x -> x end)
      |> Enum.concat([[[2]], [[6]]])
      |> Enum.sort(&compare?/2)

    find_index(sorted, [[2]]) * find_index(sorted, [[6]])
  end

  def find_index(list, item), do: Enum.find_index(list, fn i -> i == item end) + 1

  def compare?([l, r]), do: compare?(l, r)
  def compare?(l, r) when is_integer(l) and is_integer(r) and l < r, do: true
  def compare?(l, r) when is_integer(l) and is_integer(r) and l > r, do: false
  def compare?(l, r) when is_integer(l) and is_integer(r), do: :continue

  def compare?([lh | lt], [rh | rt]),
    do: if(is_boolean(r = compare?(lh, rh)), do: r, else: compare?(lt, rt))

  def compare?([], [_ | _]), do: true
  def compare?([_ | _], []), do: false
  def compare?([], []), do: :continue
  def compare?(l, r) when is_list(l) and is_integer(r), do: compare?(l, [r])
  def compare?(l, r) when is_integer(l) and is_list(r), do: compare?([l], r)

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn code ->
      Enum.map(code, &(Code.eval_string(&1) |> elem(0)))
    end)
  end
end
