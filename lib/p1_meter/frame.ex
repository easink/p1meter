defmodule P1Meter.Frame do
  @moduledoc """
  IEC62056-21 framing
  """

  alias __MODULE__
  alias P1Meter.Utils
  alias P1Meter.OBIS
  alias P1Meter.Context

  require Logger

  @type t :: %Frame{}

  defstruct identification: "",
            equipment: nil,
            timestamp: nil,
            measurements: []

  defmodule State do
    @moduledoc false
    defstruct identification: "",
              lines: [],
              crc: 0
  end

  @spec new(map) :: Frame.t()
  def new(attrs \\ %{}) do
    %Frame{timestamp: DateTime.utc_now()}
    |> Map.merge(attrs)
  end

  @spec get_frame(Context.t()) :: Frame.t()
  def get_frame(ctx) do
    with {:ok, state} <- start_frame(ctx) do
      get_frame_data(state, ctx)
    end
  end

  ##
  ## Private
  ##

  defp start_frame(ctx) do
    with {:ok, raw_line} <- read_line(ctx) do
      line = String.trim_trailing(raw_line)

      case line do
        "/" <> line ->
          %State{}
          |> update_crc(raw_line)
          |> add_identification(line)
          |> ok()

        _ignored ->
          start_frame(ctx)
      end
    end
  end

  defp get_frame_data(state, ctx) do
    with {:ok, raw_line} <- read_line(ctx) do
      line = String.trim_trailing(raw_line)

      case line do
        "!" <> crc ->
          state
          |> update_crc("!")
          |> done(crc)

        "" ->
          state
          |> update_crc(raw_line)
          |> get_frame_data(ctx)

        line ->
          state
          |> update_crc(raw_line)
          |> add_line(line)
          |> get_frame_data(ctx)
      end
    end
  end

  defp done(state, crc) do
    frame_crc = String.to_integer(crc, 16)

    with :ok <- validate_crc(state.crc, frame_crc) do
      # measurements = Enum.reverse(state.lines)

      %{identification: state.identification}
      |> Frame.new()
      |> OBIS.parse_measurements(state.lines)
      |> ok()
    end
  end

  defp add_identification(state, line) do
    %State{state | identification: line}
  end

  defp add_line(state, line) do
    %State{state | lines: [line | state.lines]}
  end

  defp update_crc(state, line) do
    crc = Utils.crc16(line, state.crc)
    %State{state | crc: crc}
  end

  defp validate_crc(crc, frame_crc) do
    if crc == frame_crc, do: :ok, else: {:error, :incorrect_crc}
  end

  defp read_line(ctx) do
    transport = ctx[:transport]
    transport.read_line(ctx[:conn], ctx[:timeout])
  end

  defp ok(frame), do: {:ok, frame}
end
