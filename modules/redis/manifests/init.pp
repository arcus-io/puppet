# == Class: redis
#
# Installs and configures redis
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { redis: }
#    or
#  include redis
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class redis (
    $listen_host=$redis::params::listen_host,
    $port=$redis::params::port,
    $timeout=$redis::params::timeout,
    $log_level=$redis::params::log_level,
    $databases=$redis::params::databases,
    $user=$redis::params::user,
    $password=$redis::params::password,
    $data_dir=$redis::params::data_dir,
    $log_dir=$redis::params::log_dir,
  ) inherits redis::params {

  class { 'redis::package': }
  class { 'redis::config':
    require => Class['redis::package'],
  }
  class { 'redis::service':
    require => [ Class['redis::config'], Class['redis::package'] ],
  }
}
