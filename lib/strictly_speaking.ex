defmodule StrictlySpeaking do
  @moduledoc """
  Implements a single function, `say/2`, which returns textual representation
  of a given integer in a given language.
  """

  @doc """
  Accepts an integer and a language symbol. Returns a string containing
  human-readable representation of given number.

  List of supported languages:

    * `:ua` - Ukrainian,
    * `:en` - English.

  Raises an ArgumentError in case `number` is not a positive integer,
  or `language` is not among supported.

  ## Examples

      iex> StrictlySpeaking.say(7, :ua)
      "сім"

      iex> StrictlySpeaking.say(17, :en)
      "seventeen"
  """
  def say(number, :en) when is_integer(number) and number > 0, do: StrictlySpeaking.En.say(number)
  def say(number, :ua) when is_integer(number) and number > 0, do: StrictlySpeaking.Ua.say(number)

  def say(number, language) when is_integer(number) and number > 0, do: raise(ArgumentError, "Language '#{language}' is not implemented")
  def say(number, _language), do: raise(ArgumentError, "Number must be an integer greater than zero. Found: #{number}")
end
