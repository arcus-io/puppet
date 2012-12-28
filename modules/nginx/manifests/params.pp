class nginx::params {
  $iptables_hosts = hiera_array('nginx_iptables_hosts', ['0.0.0.0'])
}
