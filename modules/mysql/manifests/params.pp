class mysql::params {
  $root_password = hiera('mysql_root_password', 'root')
  $enable_remote_root = hiera('mysql_enable_remote_root', false)
  $iptables_hosts = hiera_array('mysql_iptables_hosts', ['0.0.0.0/0'])
}
