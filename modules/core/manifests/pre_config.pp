class core::pre_config inherits core::params {
  if ! defined(File['/etc/hosts.d']) {
    file { '/etc/hosts.d':
      ensure    => directory,
      owner     => root,
      group     => root,
      mode      => 0660,
    }
  }
}
