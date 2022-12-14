defmodule AdventOfCode.Day07 do
  def part1(input) do
    Enum.reduce(input, {%{}, []}, &build_fs(&1, &2))
    |> elem(0)
    |> Map.values()
    |> Enum.filter(fn x -> x <= 100_000 end)
    |> Enum.sum()
  end

  def part2(input) do
    dir_by_size =
      Enum.reduce(input, {%{}, []}, &build_fs(&1, &2))
      |> elem(0)

    target = Map.get(dir_by_size, "/") - 40_000_000

    dir_by_size
    |> Map.values()
    |> Enum.filter(fn x -> x >= target end)
    |> Enum.sort()
    |> hd
  end

  def parseInput(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&parse(&1))
  end

  defp build_fs({:ls}, acc), do: acc

  defp build_fs({:cd, ".."}, {dirmap, [_ | dir]}),
    do: {dirmap, dir}

  defp build_fs({:cd, dir}, {dirmap, current}),
    do: {dirmap, [dir | current]}

  defp build_fs({:dir, dir}, {dirmap, current}),
    do: {Map.put(dirmap, Enum.reverse([dir | current]) |> Enum.join("/"), 0), current}

  defp build_fs({:file, _, size}, {dirmap, curr}) do
    dir = Enum.reverse(curr)

    updated =
      Enum.reduce(Range.new(length(curr), 1), dirmap, fn segments, acc ->
        key = Enum.take(dir, segments) |> Enum.join("/")
        Map.update(acc, key, size, &(&1 + size))
      end)

    {updated, curr}
  end

  def parse(cmd), do: String.split(cmd, " ") |> parse_cmd
  def parse_cmd(["$", "cd", dir]), do: {:cd, dir}
  def parse_cmd(["$", "ls"]), do: {:ls}
  def parse_cmd(["dir", dir]), do: {:dir, dir}
  def parse_cmd([size, name]), do: {:file, name, String.to_integer(size)}
end
