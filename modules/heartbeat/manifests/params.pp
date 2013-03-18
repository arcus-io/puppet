class heartbeat::params {
  $iptables_hosts = hiera_array('heartbeat_iptables_hosts', ['0.0.0.0/0'])
}
