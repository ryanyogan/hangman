defmodule Hangman.MixProject do
  use Mix.Project

  def project do
    [
      app: :hangman,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dictionary, github: "ryanyogan/dictionary", version: "0.2.0"},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end
end
