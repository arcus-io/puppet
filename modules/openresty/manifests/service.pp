class openresty::service {
  service { 'openresty':
    provider => 'upstart',
    ensure   => running,
  }
}
