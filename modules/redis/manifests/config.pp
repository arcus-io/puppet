class redis::config inherits redis::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  $user = $redis::user
  $log_dir = $redis::log_dir
  $iptables_hosts = $redis::params::iptables_hosts
  user { 'redis::config::redis_user':
    name    => "${redis::user}",
    comment => "Redis",
    home    => "/home/${redis::user}",
    ensure  => present,
  }
  file { 'redis::config::log_dir':
    ensure  => directory,
    path    => "${redis::log_dir}",
    mode    => 0750,
    owner   => "${redis::user}",
  }
  file { 'redis::config::data_dir':
    ensure  => directory,
    path    => "${redis::data_dir}",
    owner   => "${redis::user}",
    mode    => 0750,
    require => User["redis::config::redis_user"],
  }
  # manual symlink to /lib/init/upstart-job for http://projects.puppetlabs.com/issues/14297
  file { 'redis::config::redis_upstart_link':
    ensure  => link,
    path    => '/etc/init.d/redis',
    target  => '/lib/init/upstart-job',
    alias   => "redis-upstart-job"
  }
  file { 'redis::config::redis_upstart':
    path    => '/etc/init/redis.conf',
    content => template('redis/redis.conf.upstart.erb'),
    owner   => root,
    mode    => 0644,
    require => File['redis::config::redis_upstart_link'],
    notify  => Service['redis'],
  }
  file { 'redis::config::redis_logrotate':
    path    => '/etc/logrotate.d/redis',
    content => template('redis/redis.logrotate.erb'),
    owner   => root,
    mode    => 0644,
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.redis':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('redis/iptables.erb'),
  }
  # tools
  file { '/usr/bin/arcus-show-hiera':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0770,
    content => template('redis/arcus-show-hiera.erb')
  }
}
