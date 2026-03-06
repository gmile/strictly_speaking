Benchee.run(
  %{
    "EN: small (7)" => fn -> StrictlySpeaking.say(7, :en) end,
    "EN: teens (17)" => fn -> StrictlySpeaking.say(17, :en) end,
    "EN: tens (80)" => fn -> StrictlySpeaking.say(80, :en) end,
    "EN: hundreds (227)" => fn -> StrictlySpeaking.say(227, :en) end,
    "EN: thousands (9_880)" => fn -> StrictlySpeaking.say(9_880, :en) end,
    "EN: large (117_227)" => fn -> StrictlySpeaking.say(117_227, :en) end,
    "EN: millions (123_456_789)" => fn -> StrictlySpeaking.say(123_456_789, :en) end,
    "UA: small (7)" => fn -> StrictlySpeaking.say(7, :ua) end,
    "UA: tens (80)" => fn -> StrictlySpeaking.say(80, :ua) end,
    "UA: thousands (9_880)" => fn -> StrictlySpeaking.say(9_880, :ua) end,
    "UA: large (117_227)" => fn -> StrictlySpeaking.say(117_227, :ua) end,
    "UA: millions (123_456_789)" => fn -> StrictlySpeaking.say(123_456_789, :ua) end
  },
  memory_time: 2
)
