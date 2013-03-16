class heartbeat::package inherits heartbeat::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package["heartbeat"]) { package { "heartbeat": ensure => installed, } }
}
