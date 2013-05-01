class arcus::params {
  $arcus_api_key = hiera('arcus_api_key', 'arcus-default-key')
  $arcus_api_url = hiera('arcus_api_url', 'https://nucleo.arcus.io/api/v1')
  $use_puppetdb = hiera('use_puppetdb', 'true')
  $collectd_host = hiera('collectd_host', 'localhost')
  $collectd_port = hiera('collectd_port', '25826')
  $puppet_dashboard_url = hiera('puppet_dashboard_url', 'http://puppet.local:3000')
  $syslog_server = hiera('syslog_server', 'localhost')
  $memcached_listen_host = hiera('memcached_listen_host', '127.0.0.1')
  $memcached_port = hiera('memcached_port', '11211')
  $mysql_root_password = hiera('mysql_root_password', 'root')
  $iptables_hosts = hiera_array('arcus_iptables_hosts', ['0.0.0.0/0'])
  $module_dirs = hiera_array('module_dirs', [])
}
