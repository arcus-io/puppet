# == Class: sentry
#
# Installs and configures sentry
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { sentry: }
#    or
#  include sentry
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class sentry (
  ) inherits sentry::params {

  class { 'sentry::package': }
  class { 'sentry::config':
    require => Class['sentry::package'],
  }
  class { 'sentry::service':
    require => [ Class['sentry::config'], Class['sentry::package'] ],
  }
}
