# == Class: virtualenv
#
# Installs and configures virtualenv
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { virtualenv: }
#    or
#  include virtualenv
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2013 Arcus, unless otherwise noted.
#
class virtualenv inherits virtualenv::params {
  class { 'virtualenv::package': }
  class { 'virtualenv::config':
    require => Class['virtualenv::package'],
  }
  class { 'virtualenv::service':
    require => [ Class['virtualenv::config'], Class['virtualenv::package'] ],
  }
}
