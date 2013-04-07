class redis::params {
  $iptables_hosts = hiera_array('redis_iptables_hosts', ['0.0.0.0/0'])
  $redis_url = "http://redis.googlecode.com/files/redis-2.6.12.tar.gz"
  $listen_host = hiera('redis_listen_host', '0.0.0.0')
  $port = hiera('redis_port', '6379')
  $timeout = hiera('redis_timeout', '300')
  $log_level = hiera('redis_log_level', 'notice')
  $databases = hiera('redis_databases', '16')
  $user = hiera('redis_user', 'redis')
  $password = hiera('redis_password', 'nil')
  $data_dir = hiera('redis_data_dir', '/opt/redis')
  $log_dir = hiera('redis_log_dir', '/var/log/redis')
}
