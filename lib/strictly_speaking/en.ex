defmodule StrictlySpeaking.En do
  @singles {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

  @tens {"twenty", "thirty", "fourty", "fifty", "sixty", "seventy", "eighty", "ninety"}
  @teens {"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}

  @bigs {"thousand", "million", "billion", "trillion"}

  @doc """
  Accepts an integer. Returns a string containing human-readable representation of given number.

  ## Examples

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

  """
  def say(number, acc \\ << >>, order \\ 0)

  def say(number, acc, order) when number > 0 do
    {div1000, rem1000} = {div(number, 1000), rem(number, 1000)}
    {div100, rem100} = {div(rem1000, 100), rem(rem1000, 100)}
    {div10, rem10} = {div(rem100, 10), rem(rem100, 10)}

    result =
      case {order, div100, div10, rem10} do
        {_, 0, 0, 0} -> << >>
        {0, 0, 0, s} -> << elem(@singles, s - 1)::binary >>
        {0, 0, 1, s} -> << elem(@teens, s)::binary >>
        {0, 0, t, s} -> << elem(@tens, t - 2)::binary, ?\s, elem(@singles, s - 1)::binary >>

        {0, h, 0, 0} -> << elem(@singles, h - 1)::binary, ?\s, "hundred" >>
        {0, h, 0, s} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, "and", ?\s, elem(@singles, s - 1)::binary >>
        {0, h, 1, s} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, "and", ?\s, elem(@teens, s)::binary >>
        {0, h, t, s} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, "and", ?\s, elem(@tens, t - 2)::binary, ?\s, elem(@singles, s - 1)::binary >>

        {o, 0, 0, s} -> << elem(@singles, s - 1)::binary, ?\s, elem(@bigs, o - 1)::binary >>
        {o, 0, 1, s} -> << elem(@teens, s)::binary, ?\s, elem(@bigs, o - 1)::binary >>
        {o, 0, t, s} -> << elem(@tens, t - 1)::binary, ?\s, elem(@singles, s - 1)::binary, ?\s, elem(@bigs, o - 1)::binary >>

        {o, h, 0, 0} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, elem(@bigs, o - 1)::binary >>
        {o, h, 0, s} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, "and", ?\s, elem(@singles, s - 1)::binary, ?\s, elem(@bigs, o - 1)::binary >>
        {o, h, 1, s} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, "and", ?\s, elem(@teens, s)::binary, ?\s, elem(@bigs, o - 1)::binary >>
        {o, h, t, s} -> << elem(@singles, h - 1)::binary, ?\s, "hundred", ?\s, "and", ?\s, elem(@tens, t - 2)::binary, ?\s, elem(@singles, s - 1)::binary, ?\s, elem(@bigs, o - 1)::binary >>
      end

    case {result, div1000} do
      {<< >>,  div1000} -> say(div1000, acc, order + 1)
      {result,       0} -> << result::binary, acc::binary >>
      {result, div1000} -> say(div1000, << ?\s, result::binary, acc::binary >>, order + 1)
    end
  end
end

