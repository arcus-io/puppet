class memcached::service {
  if ! defined(Service['memcached']) {
    service { 'memcached':
      ensure  => running,
    }
  }
}
