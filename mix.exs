defmodule StrictlySpeaking.MixProject do
  use Mix.Project

  def project do
    [
      app: :strictly_speaking,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Ievgen Pyrogov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gmile/strictly_speaking"}
    ]
  end

  defp description do
    "A library to pronounce numbers"
  end
end
