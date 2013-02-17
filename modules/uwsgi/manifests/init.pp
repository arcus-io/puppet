# == Class: uwsgi
#
# Installs and configures uwsgi
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { uwsgi: }
#    or
#  include uwsgi
#
# === Authors
#
# Arcus <support@arcus.io>
#
# === Copyright
#
# Copyright 2012 Arcus, unless otherwise noted.
#
class uwsgi inherits uwsgi::params {
  class { 'uwsgi::package': }
  class { 'uwsgi::config':
    require => Class['uwsgi::package'],
  }
  class { 'uwsgi::service':
    require => [ Class['uwsgi::config'], Class['uwsgi::package'] ],
  }
}
