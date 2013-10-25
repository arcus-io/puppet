class sensu::config inherits sensu::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  $hostname = $::hostname
  $fqdn = $::fqdn
  $sensu_alert_title = $sensu::params::sensu_alert_title
  $sensu_alert_to_address = $sensu::params::sensu_alert_to_address
  $sensu_alert_to_urgent_address = $sensu::params::sensu_alert_to_urgent_address
  $sensu_alert_from_address = $sensu::params::sensu_alert_from_address
  # this is a custom function (arcus/lib/puppet/parser/functions/get_arcus_modules.rb
  # that queries the Nucleo ENC to get the current list of modules (classes)
  $use_nucleo_enc = hiera('use_nucleo_enc', false) ? {
    'true'  => true,
    default => false,
  }
  $subscriptions = $use_nucleo_enc ? {
    true    => get_arcus_modules(hiera('arcus_api_url'), hiera('arcus_api_key')),
    default => get_enc_classes(),
  }
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
  $iptables_hosts = $sensu::params::iptables_hosts
  # iptables
  file { '/tmp/.arcus.iptables.rules.sensu':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('sensu/iptables.erb'),
  }
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
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check-http.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check-http.rb',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/nginx-metrics.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/nginx-metrics.rb',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_disk.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_disk.rb',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_load.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_load.rb',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_mem.sh':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_mem.sh',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_mysql_disk.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_mysql_disk.rb',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_rabbitmq_messages.rb':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_rabbitmq_messages.rb',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_rds.py':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_rds.py',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_solr_multicore_by_names.py':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_solr_multicore_by_names.py',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  file { '/etc/sensu/plugins/check_ssl.sh':
    ensure  => present,
    source  => 'puppet:///modules/sensu/plugins/check_ssl.sh',
    mode    => 0755,
    require => File['/etc/sensu/plugins'],
  }
  # sensu
  exec { 'sensu::config::restart_sensu_api':
    command     => 'service sensu-api stop ; service sensu-api start',
    onlyif      => 'service sensu-api status',
    refreshonly => true,
  }
  exec { 'sensu::config::restart_sensu_server':
    command     => 'service sensu-server stop ; service sensu-server start',
    onlyif      => 'service sensu-server status',
    refreshonly => true,
  }
  exec { 'sensu::config::restart_sensu_client':
    command     => 'service sensu-client stop ; service sensu-client start',
    refreshonly => true,
  }
  file { '/etc/sensu/handlers/mail.py':
    ensure  => present,
    source  => 'puppet:///modules/sensu/handlers/mail.py',
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Package['sensu'],
    notify  => [ Exec['sensu::config::restart_sensu_server'], Exec['sensu::config::restart_sensu_api'] ],
  }
  file { '/etc/sensu/conf.d/handler_mail.json':
    ensure  => present,
    content => template('sensu/handlers/handler_mail.json.erb'),
    owner   => root,
    group   => root,
    mode    => 0644,
    require => Package['sensu'],
    notify  => [ Exec['sensu::config::restart_sensu_server'], Exec['sensu::config::restart_sensu_api'] ],
  }
  file { '/etc/sensu/conf.d/handler_mail_urgent.json':
    ensure  => present,
    content => template('sensu/handlers/handler_mail_urgent.json.erb'),
    owner   => root,
    group   => root,
    mode    => 0644,
    require => Package['sensu'],
    notify  => [ Exec['sensu::config::restart_sensu_server'], Exec['sensu::config::restart_sensu_api'] ],
  }
  file { '/etc/sensu/conf.d/checks.json':
    ensure  => present,
    content => template('sensu/checks.json.erb'),
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => [ Exec['sensu::config::restart_sensu_server'], Exec['sensu::config::restart_sensu_api'], Exec['sensu::config::restart_sensu_client'] ],
  }
}
