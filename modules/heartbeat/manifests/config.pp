class heartbeat::config inherits heartbeat::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  $iptables_hosts = $heartbeat::iptables_hosts
  file { '/etc/ha.d/ha.cf.sample':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('heartbeat/ha.cf.sample.erb'),
  }
  file { '/etc/ha.d/haresources.sample':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('heartbeat/haresources.sample.erb'),
  }
  file { '/etc/ha.d/authkeys.sample':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('heartbeat/authkeys.sample.erb'),
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.heartbeat':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('heartbeat/iptables.erb'),
  }
}
