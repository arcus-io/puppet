# == Class: iptables
#
# Installs and configures iptables
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { iptables: }
#    or
#  include iptables
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class iptables inherits iptables::params {
  if ! defined(Stage["post"]) {
    stage { 'post': require => Stage['main'] }
  }
  class { 'iptables::package': }
  class { 'iptables::config':
    require => Class['iptables::package'],
  }
  class { 'iptables::service':
    require => [ Class['iptables::config'], Class['iptables::package'] ],
  }
  class { 'iptables::post_config':
    stage => 'post',
  }
}
