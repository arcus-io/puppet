class openresty::config inherits openresty::params {
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
}
