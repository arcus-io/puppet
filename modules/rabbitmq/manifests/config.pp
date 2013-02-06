class rabbitmq::config inherits rabbitmq::params {
  $iptables_hosts = $rabbitmq::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  exec { 'rabbitmq::config::create_user':
    command   => "rabbitmqctl add_user ${rabbitmq::rabbitmq_user} ${rabbitmq::rabbitmq_password}",
    unless    => "rabbitmqctl list_users | grep ${rabbitmq::rabbitmq_user}",
    user      => root,
    notify    => Exec['rabbitmq::config::permissions'],
  }
  exec { 'rabbitmq::config::permissions':
    command     => "rabbitmqctl set_permissions ${rabbitmq::rabbitmq_user} \".*\" \".*\" \".*\"",
    user        => root,
    refreshonly => true,
    notify      => Exec['rabbitmq::config::enable_management_plugin'],
  }
  exec { 'rabbitmq::config::enable_management_plugin':
    command     => "bash -c '/usr/lib/rabbitmq/lib/rabbitmq_*/sbin/rabbitmq-plugins enable rabbitmq_management'",
    user        => 'root',
    environment => "HOME=/root",
    refreshonly => true,
    notify      => Service['rabbitmq-server'],
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.rabbitmq':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('rabbitmq/iptables.erb'),
  }
}
