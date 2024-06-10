defmodule P1MeterCRCTest do
  @moduledoc false
  use ExUnit.Case

  test "crc16/1" do
    assert P1Meter.Utils.crc16("123456789") == 0xbb3d
  end

  test "crc16/2" do
    crc =  P1Meter.Utils.crc16("12345")
    assert P1Meter.Utils.crc16("6789", crc) == 0xbb3d
  end
end
