class redis::params {
  $redis_url = "http://redis.googlecode.com/files/redis-2.4.15.tar.gz"
  $listen_host = hiera('redis_listen_host')
  $port = hiera('redis_port')
  $timeout = hiera('redis_timeout')
  $log_level = hiera('redis_log_level')
  $databases = hiera('redis_databases')
  $user = hiera('redis_user')
  $password = hiera('redis_password')
  $data_dir = hiera('redis_data_dir')
  $log_dir = hiera('redis_log_dir')
}
