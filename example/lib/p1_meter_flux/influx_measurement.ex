defmodule P1MeterFlux.Influx.Measurement do
  @moduledoc false

  use Instream.Series

  alias P1Meter.Frame
  alias P1MeterFlux.Influx

  series do
    measurement("p1meter")

    tag(:id)
    tag(:equipment)

    tag(:direction)
    tag(:energy)
    tag(:power)
    tag(:voltage)
    tag(:amperage)
    tag(:phase)
    tag(:unit)

    field(:value)
  end

  @spec from_frame(Frame.t()) :: Influx.Measurement.t()
  def from_frame(frame) do
    timestamp = DateTime.to_unix(frame.timestamp, :nanosecond)

    for measurement <- frame.measurements do
      measurement.tags
      |> Enum.reduce(%Influx.Measurement{}, fn {tag, val}, acc ->
        set_tag(acc, tag, val)
      end)
      |> set_tag(:id, frame.identification)
      |> set_tag(:equipment, frame.equipment || "unknown")
      |> set_timestamp(timestamp)
      |> set_tag(:unit, measurement.unit)
      |> set_field(:value, measurement.value)
    end
  end

  defp set_tag(data, _tag, nil), do: data

  defp set_tag(data, tag, value) do
    %{data | tags: %{data.tags | tag => value}}
  end

  defp set_field(data, field, value) do
    %{data | fields: %{data.fields | field => value}}
  end

  defp set_timestamp(data, timestamp) do
    %{data | timestamp: timestamp}
  end
end
