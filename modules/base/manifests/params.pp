class base::params {
  $puppet_dashboard_url = hiera('puppet_dashboard_url')
  $syslog_server = hiera('syslog_server')
}
