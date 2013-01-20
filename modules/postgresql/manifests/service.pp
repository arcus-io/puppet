class postgresql::service {
  service { 'postgresql':
    ensure  => running,
  }
}
