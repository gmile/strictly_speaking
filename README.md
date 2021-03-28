# Strictly Speaking

[![Build Status](https://github.com/gmile/strictly_speaking/actions/workflows/ci.yml/badge.svg)](https://github.com/gmile/strictly_speaking/actions/workflows/ci.yml)

Turns numbers into words. Similar to [humanize](https://github.com/radar/humanize).

## Installation

The package can be installed by adding `strictly_speaking` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:strictly_speaking, "~> 0.1.0"}
  ]
end
```

Documentation can be found at https://hexdocs.pm/strictly_speaking.

## Usage

```elixir
StrictlySpeaking.say(7, :ua)
# => "сім"

StrictlySpeaking.say(17, :en)
# => "seventeen"
```

## License

`strictly_speaking` is licensed under the MIT license, see the [LICENSE](LICENSE)
file.
