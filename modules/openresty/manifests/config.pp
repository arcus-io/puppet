class openresty::config inherits openresty::params {
  $iptables_hosts = $openresty::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  file { '/etc/init/openresty.conf':
    ensure  => present,
    source  => 'puppet:///modules/openresty/openresty.conf',
    owner   => root,
    group   => root,
    mode    => 0755,
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.openresty':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('openresty/iptables.erb'),
  }
}
