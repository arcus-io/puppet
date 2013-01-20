class apache2::config inherits apache2::params {
  $www_user = 'www-data'
  $iptables_hosts = $apache2::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.apache2':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('apache2/iptables.erb'),
  }
}
