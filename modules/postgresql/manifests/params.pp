class postgresql::params {
  $iptables_hosts = hiera_array('postgresql_iptables_hosts', ['0.0.0.0'])
}
