class rabbitmq::params {
  $iptables_hosts = hiera_array('rabbitmq_iptables_hosts', ['0.0.0.0/0'])
  $rabbitmq_user = hiera('rabbitmq_user', 'rmquser')
  $rabbitmq_password = hiera('rabbitmq_password', 'rmqpassword')
}
