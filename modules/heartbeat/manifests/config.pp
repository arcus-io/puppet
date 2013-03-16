class heartbeat::config inherits heartbeat::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
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
}
