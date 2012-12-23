class mongodb::params {
  $db_path = hiera('mongodb_db_path', '/var/lib/mongodb')
  $port = hiera('mongodb_port', '27017')
  $log_file = hiera('mongodb_log_file', '/var/log/mongodb/mongodb.log')
  $replica_set = hiera('mongodb_replica_set', 'master')
}
