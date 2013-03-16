class virtualenv::config inherits virtualenv::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
}
