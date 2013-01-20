class postgresql::config inherits postgresql::params {
  $iptables_hosts = $postgresql::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
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
