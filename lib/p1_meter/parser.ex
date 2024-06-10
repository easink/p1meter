# credo:disable-for-this-file Credo.Check.Readability.ModuleNames
defmodule P1Meter.Parser do
  @moduledoc false

  alias P1Meter.Frame
  alias P1Meter.Measurement

  require Logger

  def parse_measurements(frame, lines) do
    Enum.reduce(lines, frame, fn line, acc ->
      parse_measurement(acc, line)
    end)
  end

  def parse_measurement(frame, line) do
    # pattern = ~r/^(?<obis>[0-9-:.]+)\((?<value>[^)]+)\)$/

    # Regex.named_captures(pattern, line)
    # |> dbg()

    [obis, value, ""] = String.split(line, ["(", ")"])

    case obis do
      "0-0:" <> _obis ->
        case obis do
          "0-0:1.0.0" <> _obis ->
            {value, _unit} = parse_value(:timestamp, value)
            %Frame{frame | timestamp: value}

          "0-0:96.1.0" <> _obis ->
            {value, _unit} = parse_value(:octet_string, value)
            %Frame{frame | equipment: value}

          _unknown ->
            Logger.warning("Unknown obis #{obis}")
            frame
        end

      "1-0:" <> _obis ->
        case Measurement.get(obis) do
          nil ->
            Logger.warning("Could not handle obis #{obis}")
            frame

          measurement ->
            {value, unit} = parse_value(measurement.type, value)

            measurement =
              measurement
              |> add_value(value)
              |> add_unit(unit)

            %Frame{frame | measurements: [measurement | frame.measurements]}
        end
    end
  end

  defp parse_value(type, value) do
    case type do
      :timestamp ->
        {parse_timestamp(value), ""}

      :octet_string ->
        {Base.decode16!(value), ""}

      :float ->
        [value, unit] = String.split(value, "*")
        {String.to_float(value), unit}

      unknown_type ->
        Logger.warning("Unknown type: #{unknown_type}")
        {value, "unknown"}
    end
  end

  defp parse_timestamp(timestamp) do
    # ignore DST, DST if X == S, else X == W
    [year, month, day, hour, minute, second] =
      for <<x::binary-2 <- timestamp>>, do: String.to_integer(x)

    {{2000 + year, month, day}, {hour, minute, second}}
    |> NaiveDateTime.from_erl!()
    |> DateTime.from_naive!("Etc/UTC")
  end

  defp add_value(measurement, value) do
    %Measurement{measurement | value: value}
  end

  defp add_unit(measurement, unit) do
    %Measurement{measurement | unit: unit}
  end

  # defp obis() do
  #    %{
  #      "1.0.0" => %{description: "Datum och tid", type: "Formatet YYMMDDhhmmssX"},
  #      "1.8.0" => %{description: "Mätarställning Aktiv Energi Uttag", type: ""},
  #      "2.8.0" => %{description: "Mätarställning Aktiv Energi Inmatning", type: ""},
  #      "3.8.0" => %{description: "Mätarställning Reaktiv Energi Uttag", type: ""},
  #      "4.8.0" => %{description: "Mätarställning Reaktiv Energi Inmatning", type: ""},
  #      "1.7.0" => %{description: "Aktiv Effekt Uttag", type: "Momentan trefaseffekt"},
  #      "2.7.0" => %{description: "Aktiv Effekt Inmatning", type: "Momentan trefaseffekt"},
  #      "3.7.0" => %{description: "Reaktiv Effekt Uttag", type: "Momentan trefaseffekt"},
  #      "4.7.0" => %{description: "Reaktiv Effekt Inmatning", type: "Momentan trefaseffekt"},
  #      "21.7.0" => %{description: "L1 Aktiv Effekt Uttag", type: "Momentan effekt"},
  #      "22.7.0" => %{description: "L1 Aktiv Effekt Inmatning", type: "Momentan effekt"},
  #      "41.7.0" => %{description: "L2 Aktiv Effekt Uttag", type: "Momentan effekt"},
  #      "42.7.0" => %{description: "L2 Aktiv Effekt Inmatning", type: "Momentan effekt"},
  #      "61.7.0" => %{description: "L3 Aktiv Effekt Uttag", type: "Momentan effekt"},
  #      "62.7.0" => %{description: "L3 Aktiv Effekt Inmatning", type: "Momentan effekt"},
  #      "23.7.0" => %{description: "L1 Reaktiv Effekt Uttag", type: "Momentan effekt"},
  #      "24.7.0" => %{description: "L1 Reaktiv Effekt Inmatning", type: "Momentan effekt"},
  #      "43.7.0" => %{description: "L2 Reaktiv Effekt Uttag", type: "Momentan effekt"},
  #      "44.7.0" => %{description: "L2 Reaktiv Effekt Inmatning", type: "Momentan effekt"},
  #      "63.7.0" => %{description: "L3 Reaktiv Effekt Uttag", type: "Momentan effekt"},
  #      "64.7.0" => %{description: "L3 Reaktiv Effekt Inmatning", type: "Momentan effekt"},
  #      "32.7.0" => %{description: "L1 Fasspänning", type: "Momentant RMS-värde"},
  #      "52.7.0" => %{description: "L2 Fasspänning", type: "Momentant RMS-värde"},
  #      "72.7.0" => %{description: "L3 Fasspänning", type: "Momentant RMS-värde"},
  #      "31.7.0" => %{description: "L1 Fasström", type: "Momentant RMS-värde"},
  #      "51.7.0" => %{description: "L2 Fasström", type: "Momentant RMS-värde"},
  #      "71.7.0" => %{description: "L3 Fasström", type: "Momentant RMS-värde"}
  #    }
  #  end
end
