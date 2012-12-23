# == Class: mongodb
#
# Installs and configures mongodb
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { mongodb: }
#    or
#  include mongodb
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class mongodb (
    $db_path=$mongodb::params::db_path,
    $port=$mongodb::params::port,
    $log_file=$mongodb::params::log_file,
    $replica_set=$mongodb::params::replica_set,
  ) inherits mongodb::params {
  class { 'mongodb::package': }
  class { 'mongodb::config':
    require => Class['mongodb::package'],
  }
  class { 'mongodb::service':
    require => [ Class['mongodb::config'], Class['mongodb::package'] ],
  }
}
