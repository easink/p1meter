# defmodule P1Meter.Measurement do
#   @moduledoc false

#   alias __MODULE__

#   defstruct name: nil,
#             type: :float,
#             value: nil,
#             unit: "",
#             obis: "",
#             description: "Dummy description"

#   def get(obis) do
#     # print_obis(obis)

#     case Map.get(obis(), obis) do
#       nil -> nil
#       m -> %Measurement{m | obis: obis}
#     end
#   end

#   def obis() do
#     %{
#       "0-0:96.1.0" => %Measurement{
#         name: :equipmentIdentifier,
#         type: :octet_string,
#         description: "Equipment identifier"
#       },
#       "0-0:1.0.0" => %Measurement{
#         name: :timestamp,
#         type: :timestamp,
#         description: "Timestamp of P1 message"
#       },
#       "1-0:1.8.0" => %Measurement{
#         name: :activeEnergyConsumed,
#         type: :float,
#         unit: "kWh",
#         description: "Total active energy has been consumed"
#       },
#       "1-0:2.8.0" => %Measurement{
#         name: :activeEnergyReturned,
#         type: :float,
#         unit: "kWh",
#         description: "Total active energy returned to the grid"
#       },
#       "1-0:3.8.0" => %Measurement{
#         name: :reactiveEnergyReceived,
#         type: :float,
#         unit: "kWh",
#         description: "Total reactive energy received from the grid"
#       },
#       "1-0:4.8.0" => %Measurement{
#         name: :reactiveEnergyReturned,
#         type: :float,
#         unit: "kWh",
#         description: "Total reactive energy returned to the grid"
#       },
#       "1-0:1.7.0" => %Measurement{
#         name: :positiveActiveInstantaneousPower,
#         type: :float,
#         unit: "kW",
#         description: "Positive active instantaneous power"
#       },
#       "1-0:2.7.0" => %Measurement{
#         name: :negativeActiveInstantaneousPower,
#         type: :float,
#         unit: "kW",
#         description: "Negative active instantaneous power"
#       },
#       "1-0:3.7.0" => %Measurement{
#         name: :positiveRectiveInstantaneousPower,
#         type: :float,
#         unit: "kW",
#         description: "Positive reactive instantaneous power"
#       },
#       "1-0:4.7.0" => %Measurement{
#         name: :negativeReactiveInstantaneousPower,
#         type: :float,
#         unit: "kW",
#         description: "Negative reactive instantaneous power"
#       },
#       "1-0:21.7.0" => %Measurement{
#         name: :positiveActiveInstantaneousPowerInPhaseI,
#         type: :float,
#         unit: "kW",
#         description: "Positive active instantaneous power in phase I"
#       },
#       "1-0:22.7.0" => %Measurement{
#         name: :negativeActiveInstantaneousPowerInPhaseI,
#         type: :float,
#         unit: "kW",
#         description: "Negative active instantaneous power in phase I"
#       },
#       "1-0:41.7.0" => %Measurement{
#         name: :positiveActiveInstantaneousPowerInPhaseII,
#         type: :float,
#         unit: "kW",
#         description: "Positive active instantaneous power in phase II"
#       },
#       "1-0:42.7.0" => %Measurement{
#         name: :negativeActiveInstantaneousPowerInPhaseII,
#         type: :float,
#         unit: "kW",
#         description: "Negative active instantaneous power in phase II"
#       },
#       "1-0:61.7.0" => %Measurement{
#         name: :positiveActiveInstantaneousPowerInPhaseIII,
#         type: :float,
#         unit: "kW",
#         description: "Positive active instantaneous power in phase III"
#       },
#       "1-0:62.7.0" => %Measurement{
#         name: :negativeActiveInstantaneousPowerInPhaseIII,
#         type: :float,
#         unit: "kW",
#         description: "Negative active instantaneous power in phase III"
#       },
#       "1-0:23.7.0" => %Measurement{
#         name: :positiveReactiveInstantaneousPowerInPhaseI,
#         type: :float,
#         unit: "kW",
#         description: "Positive reactive instantaneous power in phase I"
#       },
#       "1-0:24.7.0" => %Measurement{
#         name: :negativeReactiveInstantaneousPowerInPhaseI,
#         type: :float,
#         unit: "kW",
#         description: "Negative reactive instantaneous power in phase I"
#       },
#       "1-0:43.7.0" => %Measurement{
#         name: :positiveReactiveInstantaneousPowerInPhaseII,
#         type: :float,
#         unit: "kW",
#         description: "Positive reactive instantaneous power in phase II"
#       },
#       "1-0:44.7.0" => %Measurement{
#         name: :negativeReactiveInstantaneousPowerInPhaseII,
#         type: :float,
#         unit: "kW",
#         description: "Negative reactive instantaneous power in phase II"
#       },
#       "1-0:63.7.0" => %Measurement{
#         name: :positiveReactiveInstantaneousPowerInPhaseIII,
#         type: :float,
#         unit: "kW",
#         description: "Positive reactive instantaneous power in phase III"
#       },
#       "1-0:64.7.0" => %Measurement{
#         name: :negativeReactiveInstantaneousPowerInPhaseIII,
#         type: :float,
#         unit: "kW",
#         description: "Negative reactive instantaneous power in phase III"
#       },
#       "1-0:32.7.0" => %Measurement{
#         name: :instantaneousVoltageInPhaseI,
#         type: :float,
#         unit: "V",
#         description: "Instantaneous voltage in phase I"
#       },
#       "1-0:52.7.0" => %Measurement{
#         name: :instantaneousVoltageInPhaseII,
#         type: :float,
#         unit: "V",
#         description: "Instantaneous voltage in phase II"
#       },
#       "1-0:72.7.0" => %Measurement{
#         name: :instantaneousVoltageInPhaseIII,
#         type: :float,
#         unit: "V",
#         description: "Instantaneous voltage in phase III"
#       },
#       "1-0:31.7.0" => %Measurement{
#         name: :instantaneousCurrentInPhaseI,
#         type: :float,
#         unit: "A",
#         description: "Instantaneous current in phase I"
#       },
#       "1-0:51.7.0" => %Measurement{
#         name: :instantaneousCurrentInPhaseII,
#         type: :float,
#         unit: "A",
#         description: "Instantaneous current in phase II"
#       },
#       "1-0:71.7.0" => %Measurement{
#         name: :instantaneousCurrentInPhaseIII,
#         type: :float,
#         unit: "A",
#         description: "Instantaneous current in phase III"
#       }
#     }
#   end

#   # defp print_obis(obis) do
#   #   [a, b, c, d, e] =
#   #     obis
#   #     |> String.split(["-", ":", "."])
#   #     |> Enum.map(&String.to_integer/1)

#   #   %{
#   #     medium: obis_medium(a),
#   #     channel: obis_channel(b),
#   #     physical_unit: obis_physical_unit(c),
#   #     measurement_type: obis_measurement_type(d),
#   #     tariff: obis_tariff(e)
#   #   }
#   #   |> inspect
#   #   |> IO.puts()
#   # end

#   # defp obis_medium(1), do: "electric"
#   # defp obis_medium(8), do: "water"
#   # defp obis_medium(_n), do: "unknown"

#   # defp obis_channel(0), do: "no channel available"
#   # defp obis_channel(_n), do: "unknown"

#   # defp obis_physical_unit(_n), do: "unknown"

#   # defp obis_measurement_type(_n), do: "unknown"

#   # defp obis_tariff(n), do: "tariff #{n}"
# end
