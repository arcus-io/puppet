class postfix::params {
  $iptables_hosts = hiera_array('postfix_iptables_hosts', ['0.0.0.0/0'])
}
