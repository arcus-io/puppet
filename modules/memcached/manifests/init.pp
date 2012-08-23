# == Class: memcached
#
# Installs and configures memcached
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { memcached: }
#    or
#  include memcached
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class memcached (
    $listen_host=$memcached::params::listen_host,
    $port=$memcached::params::port,
    $memory_limit=$memcached::params::memory_limit,
    $user=$memcached::params::user,
    $connection_limit=$memcached::params::connection_limit,
    $log_file=$memcached::params::log_file,
  ) inherits memcached::params {
  class { 'memcached::package': }
  class { 'memcached::config':
    require => Class['memcached::package'],
  }
  class { 'memcached::service':
    require => [ Class['memcached::config'], Class['memcached::package'] ],
  }
}
