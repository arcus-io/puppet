class solr::params {
  $configure = hiera('solr_configure', true)
  $iptables_hosts = hiera_array('solr_iptables_hosts', ['0.0.0.0/0'])
  $solr_version = hiera('solr_version', '4')
  $solr_url = $solr_version ? {
    '3'       => 'http://apache.mirrors.tds.net/lucene/solr/3.6.2/apache-solr-3.6.2.tgz',
    default   => 'http://apache.mirrors.tds.net/lucene/solr/4.2.0/solr-4.2.0.tgz',
  }
}
