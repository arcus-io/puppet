class sentry::service {
  service { 'sentry-http':
    ensure  => running,
  }
  service { 'sentry-udp':
    ensure  => running,
  }
}
