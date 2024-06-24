defmodule P1MeterFlux.MixProject do
  use Mix.Project

  def project do
    [
      app: :p1_meter_flux,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "p1-meter",
      source_url: "https://github.com/easink/p1-meter",
      releases: [
        p1_meter: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {P1MeterFlux.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:mox, "~> 1.0", only: :test},
      {:p1_meter, path: "../"},
      {:instream, "~> 2.0"},
      {:extrace, "~> 0.5.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
    ]
  end

end
