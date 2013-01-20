class apache2::service {
  service { 'apache2':
    ensure  => running,
  }
}
