defmodule P1MeterFlux.MeasurementService do
  @moduledoc false

  use Task

  alias P1Meter.Context
  alias P1MeterFlux.Influx

  require Logger

  def start_link(_opts) do
    host = host()
    port = port()
    Logger.info("Collect data from #{:inet.ntoa host}:#{port}")
    Task.start_link(fn -> measure(host, port) end)
  end

  def measure(host, port) do
    {:ok, socket} = P1Meter.Transport.TCPClient.connect(host, port)
    # context = %Context{transport: P1Meter.Transport.TCPClient, conn: socket}

    Context.new(conn: socket, transport: transport())
    |> P1Meter.stream()
    |> Enum.map(fn frame ->
      frame
      |> Influx.Measurement.from_frame()
      |> influx_write!()
    end)
  end

  defp influx_write!(frame) do
    :ok = Influx.Connection.write(frame)
  end

  defp host() do
    host = config()[:host] || "127.0.0.1"
    host = host |> to_charlist()
    {:ok, host} = :inet.parse_address(host)
    host
  end

  defp port() do
    config()[:port] || 8080
  end

  defp transport() do
    config()[:transport] || P1Meter.Transport.TCPClient
  end

  defp config() do
    Application.get_env(:p1_meter_flux, __MODULE__, [])
  end
end
