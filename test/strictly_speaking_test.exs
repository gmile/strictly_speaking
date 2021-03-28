defmodule StrictlySpeaking.Test do
  use ExUnit.Case

  doctest StrictlySpeaking

  describe "say/2" do
    test "raises on non-integer number" do
      assert_raise ArgumentError, "Number must be an integer. Found: 1.3", fn ->
        StrictlySpeaking.say(1.3, :ua)
      end
    end

    test "raises on unsupported language" do
      assert_raise ArgumentError, "Language 'th' is not implemented", fn ->
        StrictlySpeaking.say(14, :th)
      end
    end
  end
end
