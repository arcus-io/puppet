class sensu::config inherits sensu::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  $hostname = $::hostname
  $fqdn = $::fqdn
  # this is a custom function (arcus/lib/puppet/parser/functions/get_arcus_modules.rb
  # that queries the Nucleo ENC to get the current list of modules (classes)
  $subscriptions = get_arcus_modules(hiera('arcus_api_url'), hiera('arcus_api_key'))

  $sensu_rabbitmq_host = $sensu::sensu_rabbitmq_host
  $sensu_rabbitmq_port = $sensu::sensu_rabbitmq_port
  $sensu_rabbitmq_vhost = $sensu::sensu_rabbitmq_vhost
  $sensu_rabbitmq_user = $sensu::sensu_rabbitmq_user
  $sensu_rabbitmq_pass = $sensu::sensu_rabbitmq_pass
  $sensu_redis_host = $sensu::sensu_redis_host
  $sensu_redis_port = $sensu::sensu_redis_port
  $sensu_api_host = $sensu::sensu_api_host
  $sensu_api_port = $sensu::sensu_api_port
  $sensu_dashboard_host = $sensu::sensu_dashboard_host
  $sensu_dashboard_port = $sensu::sensu_dashboard_port
  $sensu_dashboard_user = $sensu::sensu_dashboard_user
  $sensu_dashboard_pass = $sensu::sensu_dashboard_pass
  file { '/etc/sensu/config.json':
    ensure  => present,
    content => template('sensu/config.json.erb'),
    owner   => root,
    group   => 'sensu',
    mode    => 0640,
    require => Package['sensu'],
  }
  file { '/etc/sensu/conf.d/client.json':
    ensure  => present,
    content => template('sensu/client.json.erb'),
    owner   => root,
    group   => 'sensu',
    mode    => 0640,
    require => Package['sensu'],
  }
  file { '/etc/sensu/plugins':
    ensure  => directory,
    owner   => root,
    mode    => 0755,
    require => Package['sensu'],
  }
  # plugins
  file { '/etc/sensu/plugins/check-procs.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check-procs.rb',
    mode    => 0755,
  }
  file { '/etc/sensu/plugins/check-http.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check-http.rb',
    mode    => 0755,
  }
}
