class sentry::params {
  $iptables_hosts = hiera_array('sentry_iptables_hosts', ['0.0.0.0/0'])
  $sentry_db_engine = hiera('sentry_db_engine', 'postgresql_psycopg2')
  $sentry_db_host = hiera('sentry_db_host', 'localhost')
  $sentry_db_port = hiera('sentry_db_port', '5432')
  $sentry_db_name = hiera('sentry_db_name', 'sentry')
  $sentry_db_user = hiera('sentry_db_user', 'sentry')
  $sentry_db_password = hiera('sentry_db_password', 's3ntryapp')
  $sentry_url_prefix = hiera('sentry_url_prefix', 'http://sentry.local')
  $sentry_key = hiera('sentry_key', 'abcdefg12345')
  $sentry_ve_dir = hiera('sentry_ve_dir', '/opt/sentry')
}
