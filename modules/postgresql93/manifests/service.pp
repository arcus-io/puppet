class postgresql93::service {
  service { 'postgresql':
    ensure  => running,
  }
  service { 'pgbouncer':
    ensure  => running,
  }
}
