defmodule P1Meter.OBIS do
  @moduledoc false

  require Logger

  defmodule Parser do
    @moduledoc false

    import NimbleParsec

    def to_ts([y, m, d, h, min, s, _dst]) do
      {{2000 + y, m, d}, {h, min, s}}
      |> NaiveDateTime.from_erl!()
      |> DateTime.from_naive!("Etc/UTC")
    end

    float =
      ascii_string([?0..?9], min: 1)
      |> string(".")
      |> ascii_string([?0..?9], min: 1)
      |> reduce({Enum, :join, []})
      |> map({String, :to_float, []})

    measure =
      float
      |> ignore(string("*"))
      |> choice([
        string("kWh"),
        string("kW"),
        string("A"),
        string("V"),
        string("kvarh"),
        string("kvar")
      ])

    timestamp =
      integer(2)
      |> integer(2)
      |> integer(2)
      |> integer(2)
      |> integer(2)
      |> integer(2)
      |> choice([
        string("W"),
        string("S")
      ])
      |> wrap()
      |> map({__MODULE__, :to_ts, []})

    octet_string =
      ascii_string([?0..?9, ?A..?F], min: 1)
      |> map({Base, :decode16!, []})

    measures =
      ignore(string("("))
      |> choice([
        measure,
        timestamp,
        octet_string
      ])
      |> ignore(string(")"))

    obis =
      integer(1)
      |> ignore(string("-"))
      |> integer(1)
      |> ignore(string(":"))
      |> integer(min: 1, max: 3)
      |> ignore(string("."))
      |> integer(min: 1, max: 3)
      |> ignore(string("."))
      |> integer(min: 1, max: 3)
      |> concat(measures)

    # |> ignore(string("\r\n"))

    defparsec(:parse_obis, obis)

    def parse(line) do
      with {:ok, data, "", _, _, _} <- parse_obis(line) do
        {:ok, data}
      end
    end
  end

  def parse_measurements(frame, lines) do
    Enum.reduce(lines, frame, fn line, acc ->
      case parse(line) do
        %{identity: id} -> %{acc | equipment: id}
        %{timestamp: ts} -> %{acc | timestamp: ts}
        measurement -> %{acc | measurements: [measurement | acc.measurements]}
      end
    end)
  end

  def parse(line) do
    with {:ok, data} <- Parser.parse(line) do
      [group_a, group_b, group_c, group_d, group_e | rest] = data

      %{tags: []}
      |> add_media_tag(group_a)
      |> add_channel_tag(group_b)
      |> add_specific(group_a, {group_c, group_d, group_e}, rest)
    end
  end

  def zip_identity(measurements) do
    case Enum.split_with(measurements, &Map.has_key?(&1, :identity)) do
      {[], measurements} ->
        measurements

      {[%{identity: id}], measurements} ->
        Enum.map(measurements, fn m -> Map.put(m, :identity, id) end)
    end
  end

  def zip_timestamp(measurements) do
    case Enum.split_with(measurements, &Map.has_key?(&1, :timestamp)) do
      {[], measurements} ->
        measurements

      {[%{timestamp: ts}], measurements} ->
        Enum.map(measurements, fn m -> Map.put(m, :timestamp, ts) end)
    end
  end

  defp add_media_tag(measurement, group_a) do
    media = %{
      0 => :abstract,
      1 => :electric,
      4 => :heat_cost_allocator,
      5 => :cooling,
      6 => :heat,
      7 => :gas,
      8 => :cold_water,
      9 => :hot_water
    }

    media_tag = media[group_a] || :unknown
    add_tag(measurement, :media, media_tag)
  end

  defp add_channel_tag(measurement, group_b) do
    add_tag(measurement, :channel, group_b)
  end

  defp add_tag(measurement, key, val) do
    %{measurement | tags: [{key, val} | measurement.tags]}
  end

  defp add_specific(measure, group_a, group, rest) do
    case group_a do
      0 -> add_abstract_objects(measure, group, rest)
      1 -> add_electricity_objects(measure, group, rest)
    end
  end

  defp add_abstract_objects(measure, group, rest) do
    case group do
      {1, 0, 0} -> Map.put(measure, :timestamp, hd(rest))
      {96, 1, 0} -> Map.put(measure, :identity, hd(rest))
    end
  end

  defp add_electricity_objects(measure, group, rest) do
    tags = electricity_tags(group)

    measure
    |> Map.merge(%{tags: tags})
    |> add_value(rest)
  end

  defp electricity_tags({1, 8, _}), do: [power: :active, energy: :total, direction: :consume]
  defp electricity_tags({2, 8, _}), do: [power: :active, energy: :total, direction: :produce]
  defp electricity_tags({3, 8, _}), do: [power: :reactive, energy: :total, direction: :consume]
  defp electricity_tags({4, 8, _}), do: [power: :reactive, energy: :total, direction: :produce]
  defp electricity_tags({1, 7, _}), do: [power: :active, phase: :all, direction: :consume]
  defp electricity_tags({2, 7, _}), do: [power: :active, phase: :all, direction: :produce]
  defp electricity_tags({3, 7, _}), do: [power: :reactive, phase: :all, direction: :consume]
  defp electricity_tags({4, 7, _}), do: [power: :reactive, phase: :all, direction: :produce]
  defp electricity_tags({21, 7, _}), do: [power: :active, phase: :l1, direction: :consume]
  defp electricity_tags({22, 7, _}), do: [power: :active, phase: :l1, direction: :produce]
  defp electricity_tags({41, 7, _}), do: [power: :active, phase: :l2, direction: :consume]
  defp electricity_tags({42, 7, _}), do: [power: :active, phase: :l2, direction: :produce]
  defp electricity_tags({61, 7, _}), do: [power: :active, phase: :l3, direction: :consume]
  defp electricity_tags({62, 7, _}), do: [power: :active, phase: :l3, direction: :produce]
  defp electricity_tags({23, 7, _}), do: [power: :reactive, phase: :l1, direction: :consume]
  defp electricity_tags({24, 7, _}), do: [power: :reactive, phase: :l1, direction: :produce]
  defp electricity_tags({43, 7, _}), do: [power: :reactive, phase: :l2, direction: :consume]
  defp electricity_tags({44, 7, _}), do: [power: :reactive, phase: :l2, direction: :produce]
  defp electricity_tags({63, 7, _}), do: [power: :reactive, phase: :l3, direction: :consume]
  defp electricity_tags({64, 7, _}), do: [power: :reactive, phase: :l3, direction: :produce]
  defp electricity_tags({32, 7, _}), do: [voltage: :active, phase: :l1]
  defp electricity_tags({52, 7, _}), do: [voltage: :active, phase: :l2]
  defp electricity_tags({72, 7, _}), do: [voltage: :active, phase: :l3]
  defp electricity_tags({31, 7, _}), do: [amperage: :active, phase: :l1]
  defp electricity_tags({51, 7, _}), do: [amperage: :active, phase: :l2]
  defp electricity_tags({71, 7, _}), do: [amperage: :active, phase: :l3]

  defp electricity_tags(unknown) do
    Logger.warning("Unknown obis: #{inspect(unknown)}")
    []
  end

  defp add_value(measure, [value, unit]) do
    measure
    |> Map.put(:value, value)
    |> Map.put(:unit, unit)
  end
end
