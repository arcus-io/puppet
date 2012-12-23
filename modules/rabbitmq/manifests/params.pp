class rabbitmq::params {
  $rabbitmq_user = hiera('rabbitmq_user', 'rmquser')
  $rabbitmq_password = hiera('rabbitmq_password', 'rmqpassword')
}
