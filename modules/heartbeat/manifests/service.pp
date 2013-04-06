class heartbeat::service {
  if ! defined(Service['heartbeat']) {
    service { 'heartbeat':
      ensure  => running,
    }
  }
}
