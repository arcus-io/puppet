class heartbeat::package inherits heartbeat::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package["heartbeat-2"]) { package { "heartbeat-2": ensure => installed, } }
}
