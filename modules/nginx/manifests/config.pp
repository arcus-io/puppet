class nginx::config inherits nginx::params {
  $www_user = 'www-data'
  $iptables_hosts = $nginx::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    content => template('nginx/nginx.conf.erb'),
    owner   => root,
    mode    => 0644,
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  file { '/etc/nginx/sites-available/default':
    ensure  => present,
    content => template('nginx/default.conf.erb'),
    owner   => root,
    mode    => 0644,
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.nginx':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('nginx/iptables.erb'),
  }
}
