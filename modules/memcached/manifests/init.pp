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
class memcached {
  class { 'memcached::package': }
  class { 'memcached::config':
    require => Class['memcached::package'],
  }
}
