defmodule StrictlySpeaking.En do
  # mix format: off
  @singles {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
  @tens {"twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}
  @teens {"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
          "eighteen", "nineteen"}
  @bigs {"thousand", "million", "billion", "trillion"}
  # mix format: on

  @table (for n <- 0..999 do
            h = div(n, 100)
            r = rem(n, 100)
            t = div(r, 10)
            s = rem(r, 10)

            singles = @singles
            tens = @tens
            teens = @teens

            case {h, t, s} do
              {0, 0, 0} ->
                ""

              {0, 0, s} ->
                elem(singles, s)

              {0, 1, s} ->
                elem(teens, s)

              {0, t, 0} ->
                elem(tens, t - 2)

              {0, t, s} ->
                "#{elem(tens, t - 2)} #{elem(singles, s)}"

              {h, 0, 0} ->
                "#{elem(singles, h)} hundred"

              {h, 0, s} ->
                "#{elem(singles, h)} hundred and #{elem(singles, s)}"

              {h, 1, s} ->
                "#{elem(singles, h)} hundred and #{elem(teens, s)}"

              {h, t, 0} ->
                "#{elem(singles, h)} hundred and #{elem(tens, t - 2)}"

              {h, t, s} ->
                "#{elem(singles, h)} hundred and #{elem(tens, t - 2)} #{elem(singles, s)}"
            end
          end)
         |> List.to_tuple()

  @doc """
  Accepts an integer. Returns a string containing human-readable representation of given number.

  ## Examples
      iex> StrictlySpeaking.En.say(0)
      "zero"

      iex> StrictlySpeaking.En.say(7)
      "seven"

      iex> StrictlySpeaking.En.say(17)
      "seventeen"

      iex> StrictlySpeaking.En.say(23)
      "twenty three"

      iex> StrictlySpeaking.En.say(117)
      "one hundred and seventeen"

      iex> StrictlySpeaking.En.say(200)
      "two hundred"

      iex> StrictlySpeaking.En.say(217)
      "two hundred and seventeen"

      iex> StrictlySpeaking.En.say(227)
      "two hundred and twenty seven"

      iex> StrictlySpeaking.En.say(1_007)
      "one thousand seven"

      iex> StrictlySpeaking.En.say(1_017)
      "one thousand seventeen"

      iex> StrictlySpeaking.En.say(1_117)
      "one thousand one hundred and seventeen"

      iex> StrictlySpeaking.En.say(1_227)
      "one thousand two hundred and twenty seven"

      iex> StrictlySpeaking.En.say(17_117)
      "seventeen thousand one hundred and seventeen"

      iex> StrictlySpeaking.En.say(117_117)
      "one hundred and seventeen thousand one hundred and seventeen"

      iex> StrictlySpeaking.En.say(117_227)
      "one hundred and seventeen thousand two hundred and twenty seven"

      iex> StrictlySpeaking.En.say(20)
      "twenty"

      iex> StrictlySpeaking.En.say(80)
      "eighty"

      iex> StrictlySpeaking.En.say(120)
      "one hundred and twenty"

      iex> StrictlySpeaking.En.say(9_880)
      "nine thousand eight hundred and eighty"

      iex> StrictlySpeaking.En.say(20_000)
      "twenty thousand"

      iex> StrictlySpeaking.En.say(120_000)
      "one hundred and twenty thousand"

  """
  def say(0), do: "zero"
  def say(number) when is_integer(number) and number > 0, do: do_say(number, <<>>, 0)

  defp do_say(0, acc, _order), do: acc

  defp do_say(number, acc, order) do
    rest = div(number, 1000)
    group = elem(@table, rem(number, 1000))

    new_acc =
      case {group, order, acc} do
        {"", _, _} -> acc
        {g, 0, _} -> g
        {g, o, <<>>} -> <<g::binary, " ", elem(@bigs, o - 1)::binary>>
        {g, o, _} -> <<g::binary, " ", elem(@bigs, o - 1)::binary, " ", acc::binary>>
      end

    do_say(rest, new_acc, order + 1)
  end
end
