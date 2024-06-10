defmodule P1Meter.MixProject do
  use Mix.Project

  def project do
    [
      app: :p1_meter,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "p1-meter",
      source_url: "https://github.com/easink/p1-meter",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {P1Meter.Example.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:mox, "~> 1.0", only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      # example deps
      {:instream, "~> 2.0"},
    ]
  end

    defp description() do
    "Library for IEC62056-21 mode D. Used in P1/HAN ports."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "p1-meter",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/easink/p1-meter"}
    ]
  end
end
