defmodule RateLimit.MixProject do
  use Mix.Project

  def project do
    [
      app: :ratelimit,
      version: "0.1.2",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RateLimit.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
    ]
  end
end
