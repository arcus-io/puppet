class mongodb::service {
  if ! defined(Service['mongodb']) {
    service { 'mongodb':
      ensure  => running,
    }
  }
}
