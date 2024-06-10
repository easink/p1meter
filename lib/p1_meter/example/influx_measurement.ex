defmodule P1Meter.Example.Influx.Measurement do
  @moduledoc false

  use Instream.Series

  alias P1Meter.Frame
  alias P1Meter.Example.Influx

  series do
    measurement("p1meter")

    tag(:id)
    tag(:equipment)

    field(:activeEnergyConsumed)
    field(:activeEnergyReturned)
    field(:reactiveEnergyReceived)
    field(:reactiveEnergyReturned)
    field(:positiveActiveInstantaneousPower)
    field(:negativeActiveInstantaneousPower)
    field(:positiveRectiveInstantaneousPower)
    field(:negativeReactiveInstantaneousPower)
    field(:positiveActiveInstantaneousPowerInPhaseI)
    field(:negativeActiveInstantaneousPowerInPhaseI)
    field(:positiveActiveInstantaneousPowerInPhaseII)
    field(:negativeActiveInstantaneousPowerInPhaseII)
    field(:positiveActiveInstantaneousPowerInPhaseIII)
    field(:negativeActiveInstantaneousPowerInPhaseIII)
    field(:positiveReactiveInstantaneousPowerInPhaseI)
    field(:negativeReactiveInstantaneousPowerInPhaseI)
    field(:positiveReactiveInstantaneousPowerInPhaseII)
    field(:negativeReactiveInstantaneousPowerInPhaseII)
    field(:positiveReactiveInstantaneousPowerInPhaseIII)
    field(:negativeReactiveInstantaneousPowerInPhaseIII)
    field(:instantaneousVoltageInPhaseI)
    field(:instantaneousVoltageInPhaseII)
    field(:instantaneousVoltageInPhaseIII)
    field(:instantaneousCurrentInPhaseI)
    field(:instantaneousCurrentInPhaseII)
    field(:instantaneousCurrentInPhaseIII)
  end

  @spec from_frame(Frame.t()) :: Influx.Measurement.t()
  def from_frame(frame) do
    # timestamp =
    #   DateTime.utc_now()
    #   |> DateTime.to_unix(:nanosecond)

    measurement =
      %Influx.Measurement{}
      |> set_tag(:id, frame.identification)
      |> set_tag(:equipment, frame.equipment || "unknown")
      |> set_timestamp(frame.timestamp)

    Enum.reduce(frame.measurements, measurement, fn m, acc ->
      set_field(acc, m.name, m.value)
    end)
    |> dbg()
  end

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
