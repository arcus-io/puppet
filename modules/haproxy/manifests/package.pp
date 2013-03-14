class haproxy::package inherits haproxy::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package['haproxy']) { package { 'haproxy': ensure => installed, } }
}
