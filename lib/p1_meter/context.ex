defmodule P1Meter.Context do
  @moduledoc false

  @type t :: Keyword.t()

  @default_timeout 30_000
  # @default_frame_timeout 30_000

  def new(attrs \\ []) do
    Keyword.merge(default(), attrs)
  end

  defp default() do
    [
      conn: nil,
      transport: transport(),
      timeout: @default_timeout
    ]
  end

  defp transport() do
    Application.get_env(:p1_meter, :transport, P1Meter.Transport.TCPClient)
  end
end
