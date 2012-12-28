class sensu::params {
  $iptables_hosts = hiera_array('sensu_iptables_hosts', ['0.0.0.0'])
  $sensu_rabbitmq_host = hiera('sensu_rabbitmq_host', 'localhost')
  $sensu_rabbitmq_port = hiera('sensu_rabbitmq_port', '5672')
  $sensu_rabbitmq_vhost = hiera('sensu_rabbitmq_vhost', '/sensu')
  $sensu_rabbitmq_user = hiera('sensu_rabbitmq_user', 'sensu')
  $sensu_rabbitmq_pass = hiera('sensu_rabbitmq_pass', 's3n5u')
  $sensu_redis_host = hiera('sensu_redis_host', 'localhost')
  $sensu_redis_port = hiera('sensu_redis_port', '6379')
  $sensu_api_host = hiera('sensu_api_host', 'localhost')
  $sensu_api_port = hiera('sensu_api_port', '4567')
  $sensu_dashboard_host = hiera('sensu_dashboard_host', 'localhost')
  $sensu_dashboard_port = hiera('sensu_dashboard_port', '8080')
  $sensu_dashboard_user = hiera('sensu_dashboard_user', 'admin')
  $sensu_dashboard_pass = hiera('sensu_dashboard_pass', 'sensu')
}
