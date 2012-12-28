class iptables::config inherits iptables::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
}
