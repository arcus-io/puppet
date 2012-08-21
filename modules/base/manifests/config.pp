class base::config inherits base::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # timezone
  file { '/etc/timezone':
    ensure  => present,
    content => "Etc/UTC\n",
    notify  => Exec['base::config::update_tzdata'],
  }
  exec { 'base::config::update_tzdata':
    command     => 'dpkg-reconfigure -f noninteractive tzdata',
    refreshonly => true,
  }
  file { "base::config::puppet_conf":
    path    => "/etc/puppet/puppet.conf",
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('base/puppet.conf.erb'),
  }
  # syslog
  file { "base::config::default_syslog_conf":
    ensure  => present,
    path    => "/etc/rsyslog.d/50-default.conf",
    content => template("base/rsyslog-50-default.conf.erb"),
    notify  => Service["rsyslog"],
  }
  # apt update
  cron { 'base::config::cron_apt_update':
    command   => 'apt-get update',
    user      => root,
    hour      => '*',
    minute    => '05',
  }
}
