class sentry::service {
  if ! defined (Service['supervisor']) { service { 'supervisor': ensure => running, } }
}
