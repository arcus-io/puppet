class mysql::params {
  $root_password = hiera('mysql_root_password', 'root')
  $iptables_hosts = hiera_array('mysql_iptables_hosts', ['0.0.0.0'])
}
