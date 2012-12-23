class memcached::params {
  $memory_limit = hiera('memcached_memory_limit', '64')
  $listen_host = hiera('memcached_listen_host', '127.0.0.1')
  $port = hiera('memcached_port', '11211')
  $user = hiera('memcached_user', 'memcache')
  $connection_limit = hiera('memcached_connection_limit', '1024')
  $log_file = hiera('memcached_log', '/var/log/memcached.log')
}
