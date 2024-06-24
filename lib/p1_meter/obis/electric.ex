# defmodule P1Meter.Obis.Electric do
#   @moduledoc false

#   @conversion %{
#     {1, 8, 1  } => [energy: :total, direction: :consume, tariff: :low],
#     {1, 8, 2  } => [energy: :total, direction: :consume, tariff: :normal],
#     {2, 8, 1  } => [energy: :total, direction: :produce, tariff: :low],
#     {2, 8, 2  } => [energy: :total, direction: :produce, tariff: :normal],
#     {1, 7, 0  } => [power: :active, phase: :all, direction: :consume],
#     {2, 7, 0  } => [power: :active, phase: :all, direction: :produce],
#     {21, 7, 0 } => [power: :active, phase: :l1, direction: :consume],
#     {41, 7, 0 } => [power: :active, phase: :l2, direction: :consume],
#     {61, 7, 0 } => [power: :active, phase: :l3, direction: :consume],
#     {22, 7, 0 } => [power: :active, phase: :l1, direction: :produce],
#     {42, 7, 0 } => [power: :active, phase: :l2, direction: :produce],
#     {62, 7, 0 } => [power: :active, phase: :l3, direction: :produce],
#     {31, 7, 0 } => [amperage: :active, phase: :l1],
#     {51, 7, 0 } => [amperage: :active, phase: :l2],
#     {71, 7, 0 } => [amperage: :active, phase: :l3],
#     {32, 7, 0 } => [voltage: :active, phase: :l1],
#     {52, 7, 0 } => [voltage: :active, phase: :l2],
#     {72, 7, 0 } => [voltage: :active, phase: :l3],
#     {96, 7, 9 } => [power_failures: :long],
#     {96, 7, 21} => [power_failures: :short],
#     {99, 97, 0} => [power_failures: :event_log],
#     {32, 32, 0} => [voltage: :sags, phase: :l1],
#     {52, 32, 0} => [voltage: :sags, phase: :l2],
#     {72, 32, 0} => [voltage: :sags, phase: :l3],
#     {32, 36, 0} => [voltage: :swells, phase: :l1],
#     {52, 36, 0} => [voltage: :swells, phase: :l2],
#     {72, 36, 0} => [voltage: :swells, phase: :l3],
#     {96, 13, 0} => [message: :text],
#     {96, 13, 1} => [message: :code],
#     {24, 1, 0 } => [mbus: :device_type],
#     {96, 1, 0 } => [mbus: :equipment_identifier],
#     {24, 2, 1 } => [mbus: :measurement]
#   }

#   @spec to_tags({group_c, group_d, group_e) :: Keyword.t()
#   def to_tags(group) do
#     []

#   end
# end
