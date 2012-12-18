# == Class: openresty
#
# Installs and configures openresty
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { openresty: }
#    or
#  include openresty
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class openresty inherits openresty::params {
  class { 'openresty::package': }
  class { 'openresty::config':
    require => Class['openresty::package'],
  }
  class { 'openresty::service':
    require => [ Class['openresty::config'], Class['openresty::package'] ],
  }
}
