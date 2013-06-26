# Class: core
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
#  include core
#
class core (
    $collectd_host=$core::params::collectd_host,
    $collectd_port=$core::params::collectd_port,
    $puppet_dashboard_url=$core::params::puppet_dashboard_url,
    $syslog_server=$core::params::syslog_server,
  ) inherits core::params {
  if ! defined(Stage["post"]) {
    stage { 'post': require => Stage['main'] }
  }
  class { 'core::package': }
  class { 'core::users': }
  class { 'core::config':
    require => [
      Class['core::package'],
      Class['core::users'],
    ],
  }
  class { 'core::service':
    require => [ Class['core::config'], Class['core::package'] ],
  }
  class { 'core::post_config':
    stage => 'post',
  }
}
