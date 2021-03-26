defmodule StrictlySpeaking.Ua do
  @single_m {"один", "два", "три", "чотири", "п'ять", "шість", "сім", "вісім", "дев'ять"}
  @single_f {"одна", "двi", "три", "чотири", "п'ять", "шість", "сім", "вісім", "дев'ять"}

  @tens {"двадцять", "тридцять", "сорок", "п'ятдесят", "шістдесят", "сімдесят", "вісімдесят", "дев'яносто"}
  @teens {"десять", "одинадцять", "дванадцять", "тринадцять", "чотирнадцять", "п'ятнадцять", "шістнадцять", "сімнадцять", "вісімнадцять", "дев'ятндцять"}
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

  @doc """
  Accepts an integer. Returns a string containing human-readable representation of given number.

  ## Examples
      iex> StrictlySpeaking.Ua.say(7)
      "сім"

      iex> StrictlySpeaking.Ua.say(17)
      "сімнадцять"

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

  """
  def say(number, acc \\ << >>, order \\ 0)

  def say(number, acc, order) when number > 0 do
    {div1000, rem1000} = {div(number, 1000), rem(number, 1000)}
    {div100, rem100} = {div(rem1000, 100), rem(rem1000, 100)}
    {div10, rem10} = {div(rem100, 10), rem(rem100, 10)}

    sex = if order == 1, do: @single_f, else: @single_m

    result =
      case {order, div100, div10, rem10} do
        {_, 0, 0, 0} -> << >>
        {0, 0, 0, s} -> << elem(sex, s - 1)::binary >>
        {0, 0, 1, s} -> << elem(@teens, s)::binary >>
        {0, 0, t, s} -> << elem(@tens, t - 1)::binary, ?\s, elem(sex, s - 1)::binary >>

        {0, h, 0, 0} -> << elem(@hundreds, h - 1)::binary >>
        {0, h, 0, s} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(sex, s - 1)::binary >>
        {0, h, 1, s} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(@teens, s)::binary >>
        {0, h, t, s} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(@tens, t - 2)::binary, ?\s, elem(sex, s - 1)::binary >>

        {o, 0, 0, s} -> << elem(sex, s - 1)::binary, ?\s, elem(@bigs, 10 * (o - 1) + s)::binary >>
        {o, 0, 1, s} -> << elem(@teens, s)::binary, ?\s, elem(@bigs, 10 * (o - 1))::binary >>
        {o, 0, t, s} -> << elem(@tens, t - 1)::binary, ?\s, elem(sex, s - 1)::binary, ?\s, elem(@bigs, 10 * (o - 1) + s)::binary >>

        {o, h, 0, 0} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(@bigs, 10 * (o - 1))::binary >>
        {o, h, 0, s} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(sex, s - 1)::binary, ?\s, elem(@bigs, 10 * (o - 1) + s)::binary >>
        {o, h, 1, s} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(@teens, s)::binary, ?\s, elem(@bigs, 10 * (o - 1))::binary >>
        {o, h, t, s} -> << elem(@hundreds, h - 1)::binary, ?\s, elem(@tens, t - 2)::binary, ?\s, elem(sex, s - 1)::binary, ?\s, elem(@bigs, 10 * (o - 1) + s)::binary >>
      end

    case {result, div1000} do
      {<< >>,  div1000} -> say(div1000, acc, order + 1)
      {result,       0} -> << result::binary, acc::binary >>
      {result, div1000} -> say(div1000, << ?\s, result::binary, acc::binary >>, order + 1)
    end
  end
end
