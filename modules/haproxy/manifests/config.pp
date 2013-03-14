class haproxy::config inherits haproxy::params {
  $iptables_hosts = $haproxy::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  file { '/etc/default/haproxy':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('haproxy/haproxy.default.erb'),
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.haproxy':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('haproxy/iptables.erb'),
  }
}
