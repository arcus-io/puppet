# == Class: postgresql
#
# Installs and configures postgresql
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { postgresql: }
#    or
#  include postgresql
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class postgresql (
  ) inherits postgresql::params {

  class { 'postgresql::package': }
  class { 'postgresql::config':
    require => Class['postgresql::package'],
  }
  class { 'postgresql::service':
    require => [ Class['postgresql::config'], Class['postgresql::package'] ],
  }
}
