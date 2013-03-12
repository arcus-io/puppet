class solr::params {
  $configure = hiera('solr_configure', true)
  $iptables_hosts = hiera_array('solr_iptables_hosts', ['0.0.0.0/0'])
  $solr_url = 'http://apache.mirrors.tds.net/lucene/solr/4.2.0/solr-4.2.0.tgz'
}
