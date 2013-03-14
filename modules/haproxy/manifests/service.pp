class haproxy::service {
  if ! defined(Service['haproxy']) {
    service { 'haproxy':
      ensure  => running,
    }
  }
}
