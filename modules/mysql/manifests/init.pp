# == Class: mysql
#
# Installs and configures MySQL
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { mysql: }
#    or
#  include mysql
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class mysql (
    $root_password=$mysql::params::root_password,
  ) inherits mysql::params {
  class { 'mysql::package': }
  class { 'mysql::config':
    require => Class['mysql::package'],
  }
  class { 'mysql::service':
    require => [ Class['mysql::config'], Class['mysql::package'] ],
  }
}
