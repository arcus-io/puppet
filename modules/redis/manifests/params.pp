class redis::params {
  $redis_url = "http://redis.googlecode.com/files/redis-2.4.15.tar.gz"
  $listen_host = hiera('redis_listen_host', 'localhost')
  $port = hiera('redis_port', '6379')
  $timeout = hiera('redis_timeout', '300')
  $log_level = hiera('redis_log_level', 'notice')
  $databases = hiera('redis_databases', '16')
  $user = hiera('redis_user', 'redis')
  $password = hiera('redis_password', 'nil')
  $data_dir = hiera('redis_data_dir', '/opt/redis')
  $log_dir = hiera('redis_log_dir', '/var/log/redis')
}
