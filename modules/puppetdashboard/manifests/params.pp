class puppetdashboard::params {
  $config_mysql = true
  $rubygems_url = "http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz"
  $puppetlabs_deb_url = "http://apt.puppetlabs.com/puppetlabs-release_1.0-3_all.deb"
  $dashboard_db_name = hiera('puppet_dashboard_db_name', "dashboard")
  $dashboard_db_username = hiera('puppet_dashboard_db_username', "dashboard")
  $dashboard_db_password = hiera('puppet_dashboard_db_password', "d@5hB0ard")
  $iptables_hosts = hiera_array('puppet_dashboard_iptables_hosts', ['0.0.0.0/0'])
}
