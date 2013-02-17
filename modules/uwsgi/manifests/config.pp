class uwsgi::config inherits uwsgi::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
}
