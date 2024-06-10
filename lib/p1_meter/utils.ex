defmodule P1Meter.Utils do
  @moduledoc """
  Documentation of util functions for `IEC62056_21`.

  Polynomial: x^16 + x^15 + x^2 + 1 (0xa001)
  """

  import Bitwise

  def crc16(data, crc \\ 0),
    do: calc_crc16(crc, :binary.bin_to_list(data))

  def calc_crc16(crc, [byte | rest]) do
    crc
    |> bxor(byte)
    |> calc_crc16_byte()
    |> calc_crc16(rest)
  end

  def calc_crc16(crc, []), do: crc

  defp calc_crc16_byte(crc) do
    Enum.reduce(1..8, crc, fn _bit, crc ->
      if band(crc, 1) == 1,
        do: bxor(crc >>> 1, 0xA001),
        else: crc >>> 1
    end)
  end
end
