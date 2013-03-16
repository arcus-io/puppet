class heartbeat::config inherits heartbeat::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
}
