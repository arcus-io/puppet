class iptables::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
}
