class arcus::params {
  $collectd_host = hiera('collectd_host')
  $collectd_port = hiera('collectd_port')
  $puppet_dashboard_url = hiera('puppet_dashboard_url')
  $syslog_server = hiera('syslog_server')
}
