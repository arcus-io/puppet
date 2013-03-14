# == Class: haproxy
#
# Installs and configures haproxy
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { haproxy: }
#    or
#  include haproxy
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2013 Arcus, unless otherwise noted.
#
class haproxy (
    $configure=$haproxy::params::configure,
  ) inherits haproxy::params {
  class { 'haproxy::package': }
  class { 'haproxy::config':
    require   => Class['haproxy::package'],
  }
  class { 'haproxy::service':
    require => [ Class['haproxy::config'], Class['haproxy::package'] ],
  }
}
