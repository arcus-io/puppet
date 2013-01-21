class solr::params {
  $iptables_hosts = hiera_array('solr_iptables_hosts', ['0.0.0.0/0'])
}
