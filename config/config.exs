import Config

p1meter_host_address = System.get_env("P1METER_HOST_ADDRESS") || raise """
  P1METER_HOST_ADDRESS was not supplied.
  """

p1meter_host_port = System.get_env("P1METER_HOST_PORT") || "5000"

config :p1_meter, P1Meter.Example.MeasurementService,
  transport: P1Meter.Transport.TCPClient,
  host: p1meter_host_address,
  port: String.to_integer(p1meter_host_port)

# p1meter_token = "Hva9l3DtD2dg2VJm075MpUHgfOr4IlSOAgcXP5ZwPUHosGA73MYUT2ZQZi0tHJtLBpZ6oNCN6-TvCHCmqVYYgQ=="
influx_bucket_token = System.get_env("INFLUXDB_BUCKET_TOKEN") || raise """
  INFLUXDB_BUCKET_TOKEN was not supplied.
  """

influx_org = System.get_env("INFLUXDB_ORG") || raise """
  INFLUXDB_ORG was not supplied.
  """
influx_host = System.get_env("INFLUXDB_HOST") || raise """
  INFLUXDB_HOST was not supplied.
  """

config :p1_meter, P1Meter.Example.Influx.Connection,
  auth: [method: :token, token: influx_bucket_token],
  bucket: "p1meter",
  org: influx_org,
  host: influx_host,
  version: :v2

# import_config "#{Mix.env()}.exs"
