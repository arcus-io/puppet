class postgresql::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package['postgresql']) { package { 'postgresql': ensure  => installed, } }
  if ! defined(Package['libpq-dev']) { package { 'libpq-dev': ensure  => installed, } }
  if ! defined(Package['postgresql-contrib']) { package { 'postgresql-contrib': ensure  => installed, } }
  if ! defined(Package['pgbouncer']) { package { 'pgbouncer': ensure  => installed, } }
}
