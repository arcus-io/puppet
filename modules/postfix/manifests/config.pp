class postfix::config inherits postfix::params {
  $fqdn = $::fqdn
  $iptables_hosts = $postfix::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.postfix':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('postfix/iptables.erb'),
  }
  file { '/etc/mailname':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('postfix/mailname.erb'),
  }
}
