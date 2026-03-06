defmodule StrictlySpeaking.Ua do
  # mix format: off
  @singles_m {"нуль", "один", "два", "три", "чотири", "п'ять", "шість", "сім", "вісім", "дев'ять"}
  @singles_f {"нуль", "одна", "двi", "три", "чотири", "п'ять", "шість", "сім", "вісім", "дев'ять"}

  @tens {"двадцять", "тридцять", "сорок", "п'ятдесят", "шістдесят", "сімдесят", "вісімдесят", "дев'яносто"}
  @teens {"десять", "одинадцять", "дванадцять", "тринадцять", "чотирнадцять", "п'ятнадцять", "шістнадцять", "сімнадцять", "вісімнадцять", "дев'ятнадцять"}
  @hundreds {"сто", "двісті", "триста", "чотириста", "п'ятсот", "шістсот", "сімсот", "вісімсот", "дев'ятсот"}

  # TODO:
  #
  # квадрильйон
  # квінтильйон
  # секстильйон
  # септильйон
  # октильйон
  # нонильйон
  # децильйон
  @bigs {
    "тисяч",      "тисяча",   "тисячi",    "тисячi",    "тисячi",    "тисяч",      "тисяч",      "тисяч",      "тисяч",      "тисяч",
    "мільйонів",  "мільйон",  "мільйони",  "мільйони",  "мільйони",  "мільйонів",  "мільйонів",  "мільйонів",  "мільйонів",  "мільйонів",
    "мільярдів",  "мільярд",  "мільярди",  "мільярди",  "мільярди",  "мільярдів",  "мільярдів",  "мільярдів",  "мільярдів",  "мільярдів",
    "трильйонів", "трильйон", "трильйони", "трильйони", "трильйони", "трильйонів", "трильйонів", "трильйонів", "трильйонів", "трильйонів"
  }
  # mix format: on

  for {singles, name} <- [{@singles_m, :table_m}, {@singles_f, :table_f}] do
    table =
      for n <- 0..999 do
        h = div(n, 100)
        r = rem(n, 100)
        t = div(r, 10)
        s = rem(r, 10)

        tens = @tens
        teens = @teens
        hundreds = @hundreds

        case {h, t, s} do
          {0, 0, 0} -> ""
          {0, 0, s} -> elem(singles, s)
          {0, 1, s} -> elem(teens, s)
          {0, t, 0} -> elem(tens, t - 2)
          {0, t, s} -> "#{elem(tens, t - 2)} #{elem(singles, s)}"
          {h, 0, 0} -> elem(hundreds, h - 1)
          {h, 0, s} -> "#{elem(hundreds, h - 1)} #{elem(singles, s)}"
          {h, 1, s} -> "#{elem(hundreds, h - 1)} #{elem(teens, s)}"
          {h, t, 0} -> "#{elem(hundreds, h - 1)} #{elem(tens, t - 2)}"
          {h, t, s} -> "#{elem(hundreds, h - 1)} #{elem(tens, t - 2)} #{elem(singles, s)}"
        end
      end
      |> List.to_tuple()

    Module.put_attribute(__MODULE__, name, table)
  end

  @doc """
  Accepts an integer. Returns a string containing human-readable representation of given number.

  ## Examples
      iex> StrictlySpeaking.Ua.say(0)
      "нуль"

      iex> StrictlySpeaking.Ua.say(7)
      "сім"

      iex> StrictlySpeaking.Ua.say(17)
      "сімнадцять"

      iex> StrictlySpeaking.Ua.say(23)
      "двадцять три"

      iex> StrictlySpeaking.Ua.say(117)
      "сто сімнадцять"

      iex> StrictlySpeaking.Ua.say(1_117)
      "одна тисяча сто сімнадцять"

      iex> StrictlySpeaking.Ua.say(10_117)
      "десять тисяч сто сімнадцять"

      iex> StrictlySpeaking.Ua.say(117_117)
      "сто сімнадцять тисяч сто сімнадцять"

      iex> StrictlySpeaking.Ua.say(123_456_789)
      "сто двадцять три мільйони чотириста п'ятдесят шість тисяч сімсот вісімдесят дев'ять"

      iex> StrictlySpeaking.Ua.say(20)
      "двадцять"

      iex> StrictlySpeaking.Ua.say(80)
      "вісімдесят"

      iex> StrictlySpeaking.Ua.say(120)
      "сто двадцять"

      iex> StrictlySpeaking.Ua.say(9_880)
      "дев'ять тисяч вісімсот вісімдесят"

      iex> StrictlySpeaking.Ua.say(20_000)
      "двадцять тисяч"

      iex> StrictlySpeaking.Ua.say(120_000)
      "сто двадцять тисяч"

  """
  def say(0), do: "нуль"
  def say(number) when is_integer(number) and number > 0, do: do_say(number, <<>>, 0)

  defp do_say(0, acc, _order), do: acc

  defp do_say(number, acc, order) do
    rest = div(number, 1000)
    rem1000 = rem(number, 1000)
    table = if order == 1, do: @table_f, else: @table_m
    group = elem(table, rem1000)

    new_acc =
      case {group, order, acc} do
        {"", _, _} ->
          acc

        {g, 0, _} ->
          g

        {g, o, <<>>} ->
          <<g::binary, " ", elem(@bigs, bigs_index(o, rem1000))::binary>>

        {g, o, _} ->
          <<g::binary, " ", elem(@bigs, bigs_index(o, rem1000))::binary, " ", acc::binary>>
      end

    do_say(rest, new_acc, order + 1)
  end

  # Ukrainian noun declension after numerals:
  # - teens (10-19): genitive plural (index 0)
  # - otherwise: determined by ones digit
  defp bigs_index(order, rem1000) do
    tens_digit = rem1000 |> rem(100) |> div(10)
    ones_digit = rem(rem1000, 10)
    base = 10 * (order - 1)
    if tens_digit == 1, do: base, else: base + ones_digit
  end
end
