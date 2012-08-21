# == Class: graphite
#
# Installs and configures graphite
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'graphite': }
#    or
#  include graphite
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class graphite {
  class { 'graphite::package': }
  class { 'graphite::config':
    require => Class['graphite::package'],
  }
  class { 'graphite::service':
    require => [
      Class['graphite::package'],
      Class['graphite::config'],
    ],
  }
}
