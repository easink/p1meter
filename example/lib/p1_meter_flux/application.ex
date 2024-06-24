defmodule P1MeterFlux.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      P1MeterFlux.Influx.Connection,
      P1MeterFlux.MeasurementService
    ]

    opts = [strategy: :one_for_all, name: P1MeterFlux.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
