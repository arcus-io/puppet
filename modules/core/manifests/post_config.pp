class core::post_config inherits core::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # compile hosts.allow
  exec { 'core::post_config::build_hosts_allow':
    cwd       => '/etc/hosts.d',
    command   => 'cat ./*.conf > /etc/hosts.allow',
    onlyif    => 'ls -lah | grep .conf',
  }
}
