import Config

if config_env() == :prod do
  p1meter_host_address = System.get_env("P1METER_HOST_ADDRESS") || raise """
    P1METER_HOST_ADDRESS was not supplied.
    """

  p1meter_host_port = System.get_env("P1METER_HOST_PORT") || "5000"

  config :p1_meter_flux, P1MeterFlux.MeasurementService,
    transport: P1Meter.Transport.TCPClient,
    host: p1meter_host_address,
    port: String.to_integer(p1meter_host_port)

  influx_bucket_token = System.get_env("INFLUXDB_BUCKET_TOKEN") || raise """
    INFLUXDB_BUCKET_TOKEN was not supplied.
    """

  influx_org = System.get_env("INFLUXDB_ORG") || raise """
    INFLUXDB_ORG was not supplied.
    """
  influx_host = System.get_env("INFLUXDB_HOST") || raise """
    INFLUXDB_HOST was not supplied.
    """

  config :p1_meter_flux, P1MeterFlux.Influx.Connection,
    auth: [method: :token, token: influx_bucket_token],
    bucket: "p1meter",
    org: influx_org,
    host: influx_host,
    version: :v2

  config :logger, :console, format: "$metadata[$level] $message\n"
end
