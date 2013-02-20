class postgresql::service {
  service { 'postgresql':
    ensure  => running,
  }
  service { 'pgbouncer':
    ensure  => running,
  }
}
