class mongodb::params {
  $db_path = hiera('mongodb_db_path', '/var/lib/mongodb')
  $port = hiera('mongodb_port', '27017')
  $log_file = hiera('mongodb_log_file', '/var/log/mongodb/mongodb.log')
  $replica_set = hiera('mongodb_replica_set', 'master')
  $iptables_hosts = hiera_array('mongodb_iptables_hosts', ['0.0.0.0/0'])
  $auth_enabled = hiera('mongodb_auth_enabled', false)
}
