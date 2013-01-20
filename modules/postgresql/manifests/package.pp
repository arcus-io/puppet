class postgresql::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package['postgresql']) { package { 'postgresql': ensure  => installed, } }
  if ! defined(Package['libpq-dev']) { package { 'libpq-dev': ensure  => installed, } }
}
