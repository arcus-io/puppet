# == Class: heartbeat
#
# Installs and configures heartbeat
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { heartbeat: }
#    or
#  include heartbeat
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2013 Arcus, unless otherwise noted.
#
class heartbeat inherits heartbeat::params {
  class { 'heartbeat::package': }
  class { 'heartbeat::config':
    require => Class['heartbeat::package'],
  }
  class { 'heartbeat::service':
    require => [ Class['heartbeat::config'], Class['heartbeat::package'] ],
  }
}
