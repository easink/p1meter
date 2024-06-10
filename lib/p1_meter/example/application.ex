defmodule P1Meter.Example.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      P1Meter.Example.Influx.Connection,
      P1Meter.Example.MeasurementService
    ]

    opts = [strategy: :one_for_one, name: P1Meter.Example.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
