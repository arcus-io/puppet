class mysql::config inherits mysql::params {
  $os_ver = $::operatingsystemrelease
  $mysql_cmd = "mysql -u root -p${mysql::root_password}"
  $iptables_hosts = $mysql::params::iptables_hosts
  $enable_remote_root = $mysql::enable_remote_root ? {
    'true'  => true,
    true    => true,
    default => false,
  }
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  exec { 'mysql::config::set_root_password':
    command     => "mysqladmin -u root password \"${mysql::root_password}\"",
    require     => Package['mysql-server'],
    refreshonly => true,
  }
  if $enable_remote_root {
    exec { 'mysql::config::enable_remote':
      command     => "echo \"create user root@\'%\' identified by \'${mysql::root_password}\';\" | mysql -u root -p\'${mysql::root_password}\'",
      require     => Exec['mysql::config::set_root_password'],
      unless      => "echo \"select user,host from mysql.user;\" | mysql -u root -p\'${mysql::root_password}\' | grep root | grep %",
    }
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
