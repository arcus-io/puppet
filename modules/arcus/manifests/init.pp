# Class: arcus
#
# This is the core system module
#
# Parameters:
#   n/a
# Actions:
#   Installs and configures the core system
# Requires:
#   n/a
#
# Sample usage:
#
#  include arcus
#
class arcus (
    $collectd_host=$arcus::params::collectd_host,
    $collectd_port=$arcus::params::collectd_port,
    $puppet_dashboard_url=$arcus::params::puppet_dashboard_url,
    $syslog_server=$arcus::params::syslog_server,
  ) inherits arcus::params {
  class { 'arcus::package': }
  class { 'arcus::config':
    require => [ Class['arcus::package'] ],
  }
  class { 'arcus::service':
    require => [ Class['arcus::config'], Class['arcus::package'] ],
  }
}
