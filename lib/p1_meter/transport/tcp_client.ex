defmodule P1Meter.Transport.TCPClient do
  @moduledoc """
  Transport TCP Client
  """

  @behaviour P1Meter.Transport.Behaviour

  @connect_timeout 10_000
  @recv_timeout 30_000

  def connect(host, port, timeout \\ @connect_timeout) do
    :gen_tcp.connect(
      host,
      port,
      [{:active, false}, {:packet, :line}, {:buffer, 4096}, :binary],
      timeout
    )
  end

  @impl true
  def read_line(socket, timeout \\ @recv_timeout) do
    :gen_tcp.recv(socket, 0, timeout)
  end
end
