defmodule AdventOfCode.Day11 do
  defstruct number: 0, items: [], op: {:plus, 0}, test: 1, success: 0, failure: 0, inspected: 0

  def part1(input) do
    bored = fn x -> div(x, 3) end

    Enum.reduce(
      Range.new(1, 20),
      input,
      fn _, troop ->
        Enum.reduce(troop, troop, &turn(&1, &2, bored))
      end
    )
    |> monkey_business
  end

  def part2(input) do
    lcm =
      input
      |> Enum.map(fn monkey -> monkey.test end)
      |> Enum.reduce(&BasicMath.lcm(&1, &2))

    bored = fn x -> rem(x, lcm) end

    Enum.reduce(
      Range.new(1, 10_000),
      input,
      fn _, troop ->
        Enum.reduce(troop, troop, &turn(&1, &2, bored))
      end
    )
    |> monkey_business
  end

  def parseInput(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&to_monkey(&1))
  end

  defp monkey_business(troop) do
    Enum.map(troop, fn monkey -> monkey.inspected end)
    |> Enum.sort()
    |> Enum.take(-2)
    |> Enum.reduce(fn a, b -> a * b end)
  end

  defp turn(monkey, troop, bored) do
    current = Enum.at(troop, monkey.number)

    Enum.reduce(
      current.items,
      List.replace_at(troop, current.number, %{
        current
        | items: [],
          inspected: current.inspected + length(current.items)
      }),
      fn item, acc ->
        worry =
          case monkey.op do
            {:plus, "old"} -> item + item
            {:mul, "old"} -> item * item
            {:plus, val} -> item + String.to_integer(val)
            {:mul, val} -> item * String.to_integer(val)
          end
          |> bored.()

        {reciever, i} =
          case rem(worry, monkey.test) do
            0 -> {monkey.success, worry}
            _ -> {monkey.failure, worry}
          end

        target = Enum.at(acc, reciever)
        items = [i | target.items]
        updated = %{target | items: items}
        List.replace_at(acc, target.number, updated)
      end
    )
  end

  defp to_monkey([monkey, items, opt_input, test, success, failure]) do
    %AdventOfCode.Day11{
      number: get_monkey(monkey),
      items: starting_items(items),
      op: get_opt(opt_input),
      test: get_last_int(test),
      success: get_last_int(success),
      failure: get_last_int(failure)
    }
  end

  defp get_monkey(monkey) do
    String.split(monkey, " ")
    |> Enum.at(1)
    |> String.at(0)
    |> String.to_integer()
  end

  defp starting_items(item_input) do
    String.split(item_input, ":", trim: true)
    |> Enum.at(-1)
    |> String.split(",")
    |> Enum.map(&String.trim(&1))
    |> Enum.map(&String.to_integer(&1))
  end

  defp get_opt(opt_input) do
    parts = String.split(opt_input, " ")
    val = Enum.at(parts, -1)

    case Enum.at(parts, -2) do
      "+" -> {:plus, val}
      "*" -> {:mul, val}
    end
  end

  defp get_last_int(test) do
    String.split(test, " ") |> Enum.at(-1) |> String.to_integer()
  end
end
