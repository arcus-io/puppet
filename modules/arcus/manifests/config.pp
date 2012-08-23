class arcus::config inherits arcus::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # vars
  $hostname = $::hostname
  $collectd_host = hiera('collectd_host')
  $collectd_port = hiera('collectd_port')

  # timezone
  file { '/etc/timezone':
    ensure  => present,
    content => "Etc/UTC\n",
    notify  => Exec['arcus::config::update_tzdata'],
  }
  exec { 'arcus::config::update_tzdata':
    command     => 'dpkg-reconfigure -f noninteractive tzdata',
    refreshonly => true,
  }
  file { 'arcus::config::puppet_conf':
    path    => '/etc/puppet/puppet.conf',
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('arcus/puppet.conf.erb'),
  }
  # syslog
  if ! defined(File['/etc/rsyslog.d/50-default.conf']) {
    file { '/etc/rsyslog.d/50-default.conf':
      alias   => 'arcus::config::default_syslog_conf',
      ensure  => present,
      content => template('arcus/rsyslog-50-default.conf.erb'),
      notify  => Service['rsyslog'],
    }
  }
  # collectd
  file { 'arcus::config::collectd_conf':
    ensure  => present,
    path    => '/etc/collectd/collectd.conf',
    content => template('arcus/collectd.conf.erb'),
    notify  => Service['collectd'],
  }
  # apt update
  cron { 'arcus::config::cron_apt_update':
    command   => 'apt-get update',
    user      => root,
    hour      => '*',
    minute    => '05',
  }
}
