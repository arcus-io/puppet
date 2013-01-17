class postfix::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }

  if ! defined(Package['postfix']) { package { 'postfix': ensure => installed, } }
  if ! defined(Package['ca-certificates']) { package { 'ca-certificates': ensure => installed, } }
  if ! defined(Package['libsasl2-2']) { package { 'libsasl2-2': ensure => installed, } }
  if ! defined(Package['libsasl2-modules']) { package { 'libsasl2-modules': ensure => installed, } }
}
