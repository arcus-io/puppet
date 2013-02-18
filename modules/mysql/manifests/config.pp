class mysql::config inherits mysql::params {
  $os_ver = $::operatingsystemrelease
  $mysql_cmd = "mysql -u root -p${mysql::root_password}"
  $iptables_hosts = $mysql::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  exec { 'mysql::config::set_root_password':
    command     => "mysqladmin -u root password \"${mysql::root_password}\"",
    require     => Package['mysql-server'],
    refreshonly => true,
  }
  file { 'mysql::config::mysql_config':
    ensure  => present,
    path    => '/etc/mysql/my.cnf',
    content => template('mysql/my.cnf.erb'),
    require => Package['mysql-server'],
    notify  => Service['mysql'],
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.mysql':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('mysql/iptables.erb'),
  }
}
