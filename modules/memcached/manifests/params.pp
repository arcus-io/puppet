class memcached::params {
  $memory_limit = hiera('memcached_memory_limit')
  $listen_host = hiera('memcached_listen_host')
  $port = hiera('memcached_port')
  $user = hiera('memcached_user')
  $connection_limit = hiera('memcached_connection_limit')
  $log_file = hiera('memcached_log')
}
