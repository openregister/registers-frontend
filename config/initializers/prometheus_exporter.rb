if ENV['PROMETHEUS_EXPORTER']
  require 'prometheus_exporter/middleware'
  require 'prometheus_exporter/instrumentation'
  require 'uri'

  PROMETHEUS_EXPORTER = URI.parse(ENV.fetch('PROMETHEUS_EXPORTER'))


  PrometheusExporter::Client.default = PrometheusExporter::Client.new(
    host: PROMETHEUS_EXPORTER.host,
    port: PROMETHEUS_EXPORTER.port
  )

  # This reports delayed job info
  PrometheusExporter::Instrumentation::DelayedJob.register_plugin
end
