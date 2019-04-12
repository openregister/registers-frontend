if ENV['PROMETHEUS_EXPORTER']
  require 'prometheus_exporter/instrumentation'
  require 'prometheus_exporter/client'
  require 'uri'

  PROMETHEUS_EXPORTER = URI.parse(ENV['PROMETHEUS_EXPORTER'])


  PrometheusExporter::Client.default = PrometheusExporter::Client.new(
    host: PROMETHEUS_EXPORTER.host,
    port: PROMETHEUS_EXPORTER.port
  )

  PrometheusExporter::Instrumentation::DelayedJob.register_plugin
end
