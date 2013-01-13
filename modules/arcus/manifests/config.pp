class arcus::config inherits arcus::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # vars
  $arcus_api_key = $arcus::params::arcus_api_key
  $arcus_api_url = $arcus::params::arcus_api_url
  $fqdn = $::fqdn
  $hostname = $::hostname
  $collectd_host = $arcus::collectd_host
  $collectd_port = $arcus::collectd_port
  $puppet_dashboard_url = $arcus::puppet_dashboard_url
  $syslog_server = $arcus::syslog_server
  $use_nucleo_enc = hiera('use_nucleo_enc', false) ? {
    'true'  => true,
    default => false,
  }
  $classes = $arcus::config::use_nucleo_enc ? {
    true  => get_arcus_modules(hiera('arcus_api_url'), hiera('arcus_api_key')),
    default => [],
  }
  $memcached_listen_host = $arcus::params::memcached_listen_host
  $memcached_port = $arcus::params::memcached_port
  $module_dirs = $arcus::params::module_dirs
  $mysql_root_password = $arcus::params::mysql_root_password
  $sensu_alert_title = $arcus::params::sensu_alert_title
  $sensu_alert_to_address = $arcus::params::sensu_alert_to_address
  $sensu_alert_from_address = $arcus::params::sensu_alert_from_address
  $iptables_hosts = $arcus::params::iptables_hosts
  # timezone
  file { '/etc/timezone':
    ensure  => present,
    content => "Etc/UTC\n",
    notify  => Exec['arcus::config::update_tzdata'],
  }
  exec { 'arcus::config::update_tzdata':
    command     => 'dpkg-reconfigure -f noninteractive tzdata',
    refreshonly => true,
  }
  file { 'arcus::config::puppet_conf':
    path    => '/etc/puppet/puppet.conf',
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('arcus/puppet.conf.erb'),
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.default':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('arcus/iptables.erb'),
  }
  # syslog
  if ! defined(File['/etc/rsyslog.d/50-default.conf']) {
    file { '/etc/rsyslog.d/50-default.conf':
      alias   => 'arcus::config::default_syslog_conf',
      ensure  => present,
      content => template('arcus/rsyslog-50-default.conf.erb'),
      notify  => Service['rsyslog'],
    }
  }
  # collectd
  file { 'arcus::config::collectd_conf':
    ensure  => present,
    path    => '/etc/collectd/collectd.conf',
    content => template('arcus/collectd.conf.erb'),
    notify  => Service['collectd'],
    require => Package['collectd'],
  }
  # apt update
  cron { 'arcus::config::cron_apt_update':
    command   => 'apt-get update > /dev/null 2>&1',
    user      => root,
    hour      => '*',
    minute    => '05',
  }
  # sensu
  exec { 'arcus::config::restart_sensu_api':
    command     => 'service sensu-api stop ; service sensu-api start',
    onlyif      => 'service sensu-api status',
    refreshonly => true,
  }
  exec { 'arcus::config::restart_sensu_server':
    command     => 'service sensu-server stop ; service sensu-server start',
    onlyif      => 'service sensu-server status',
    refreshonly => true,
  }
  exec { 'arcus::config::restart_sensu_client':
    command     => 'service sensu-client stop ; service sensu-client start',
    refreshonly => true,
  }
  file { '/etc/sensu/handlers/mail.py':
    ensure  => present,
    source  => 'puppet:///modules/arcus/sensu/handlers/mail.py',
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Package['sensu'],
    notify  => [ Exec['arcus::config::restart_sensu_server'], Exec['arcus::config::restart_sensu_api'] ],
  }
  file { '/etc/sensu/conf.d/handler_mail.json':
    ensure  => present,
    content => template('arcus/sensu/handlers/handler_mail.json.erb'),
    owner   => root,
    group   => root,
    mode    => 0644,
    require => Package['sensu'],
    notify  => [ Exec['arcus::config::restart_sensu_server'], Exec['arcus::config::restart_sensu_api'] ],
  }
  file { '/etc/sensu/conf.d/checks.json':
    ensure  => present,
    content => template('arcus/sensu/checks.json.erb'),
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => [ Exec['arcus::config::restart_sensu_server'], Exec['arcus::config::restart_sensu_api'], Exec['arcus::config::restart_sensu_client'] ],
  }
}
