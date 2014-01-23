# == Class: postgresql93
#
# Installs and configures postgresql93
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { postgresql93: }
#    or
#  include postgresql93
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2014 Arcus, unless otherwise noted.
#
class postgresql93 (
  ) inherits postgresql93::params {

  class { 'postgresql93::package': }
  class { 'postgresql93::config':
    require => Class['postgresql93::package'],
  }
  class { 'postgresql93::service':
    require => [ Class['postgresql93::config'], Class['postgresql93::package'] ],
  }
}
