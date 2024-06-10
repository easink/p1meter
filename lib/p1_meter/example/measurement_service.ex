defmodule P1Meter.Example.MeasurementService do
  @moduledoc false

  use Task

  alias P1Meter.Context
  alias P1Meter.Example.Influx

  require Logger

  def start_link(_opts) do
    host = host()
    port = port()
    Task.start_link(fn -> measure(host, port) end)
  end

  def measure(host, port) do
    {:ok, socket} = P1Meter.Transport.TCPClient.connect(host, port)
    # context = %Context{transport: P1Meter.Transport.TCPClient, pid: socket}

    Context.new(pid: socket, transport: transport())
    |> P1Meter.stream()
    |> Enum.map(fn frame ->
      frame
      |> Influx.Measurement.from_frame()
      |> Influx.Connection.write()
    end)
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
    Application.get_env(:p1_meter, __MODULE__, [])
  end
end
