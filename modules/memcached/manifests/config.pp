class memcached::config inherits memcached::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  $listen_host = $memcached::listen_host
  $port = $memcached::port
  $memory_limit = $memcached::memory_limit
  $user = $memcached::user
  $connection_limit = $memcached::connection_limit
  $log_file = $memcached::log_file
  if ! defined(File['/etc/memcached.conf']) {
    file { '/etc/memcached.conf':
      alias   => 'memcached::config::memcached_conf',
      ensure  => present,
      content => template('memcached/memcached.conf.erb'),
      owner   => root,
      group   => root,
      mode    => 0644,
      notify  => Service['memcached'],
    }
  }
}
