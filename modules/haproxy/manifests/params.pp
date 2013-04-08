class haproxy::params {
  $iptables_hosts = hiera_array('haproxy_iptables_hosts', ['0.0.0.0/0'])
  $haproxy_ports = hiera_array('haproxy_ports', ['80', '443'])
}
