defmodule StrictlySpeakingTest do
  use ExUnit.Case
  doctest StrictlySpeaking

  test "greets the world" do
    assert StrictlySpeaking.hello() == :world
  end
end
