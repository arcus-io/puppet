class postgresql::config inherits postgresql::params {
  $iptables_hosts = $postgresql::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  file { '/etc/default/pgbouncer':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('postgresql/pgbouncer.default'),
    notify  => Service['pgbouncer'],

  }
  file { '/etc/pgbouncer/pgbouncer.ini':
    ensure  => present,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => 0640,
    content => template('postgresql/pgbouncer.ini.erb'),
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.postgresql':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('postgresql/iptables.erb'),
  }
}
