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
  # this script keeps the pgbouncer user list and postgres user passwords in sync
  file { '/etc/pgbouncer/sync_pg_users.sh':
    alias   => 'postgresql::config::sync_pg_users',
    ensure  => present,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => 0755,
    content => template('postgresql/sync_pg_users.sh.erb'),
  }
  cron { 'postgresql::config::pgbouncer_user_list_sync':
    command   => '/bin/bash /etc/pgbouncer/sync_pg_users.sh',
    user      => 'postgres',
    hour      => '*',
    minute    => '*',
    require   => File['postgresql::config::sync_pg_users'],
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
