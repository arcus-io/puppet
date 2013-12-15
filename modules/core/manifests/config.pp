class core::config inherits core::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # vars
  $arcus_api_key = $core::params::arcus_api_key
  $arcus_api_url = $core::params::arcus_api_url
  $fqdn = $::fqdn
  $hostname = $::hostname
  $collectd_host = $core::collectd_host
  $collectd_port = $core::collectd_port
  $puppet_dashboard_url = $core::puppet_dashboard_url
  $syslog_server = $core::syslog_server
  $use_nucleo_enc = hiera('use_nucleo_enc', false) ? {
    'true'  => true,
    default => false,
  }
  $use_puppetdb = hiera('use_puppetdb', false) ? {
    'true'  => true,
    default => false,
  }
  $classes = get_enc_classes([$::environment])
  $memcached_listen_host = $core::params::memcached_listen_host
  $memcached_port = $core::params::memcached_port
  $module_dirs = $core::params::module_dirs
  $mysql_root_password = $core::params::mysql_root_password
  $iptables_hosts = $core::params::iptables_hosts
  # timezone
  file { '/etc/timezone':
    ensure  => present,
    content => "Etc/UTC\n",
    notify  => Exec['core::config::update_tzdata'],
  }
  # hosts config
  if ! defined(File['/etc/hosts.d/arcus.conf']) {
    file { '/etc/hosts.d/arcus.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      content => template('core/hosts.allow.erb'),
    }
  }
  exec { 'core::config::update_tzdata':
    command     => 'dpkg-reconfigure -f noninteractive tzdata',
    refreshonly => true,
  }
  file { 'core::config::puppet_conf':
    path    => '/etc/puppet/puppet.conf',
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('core/puppet.conf.erb'),
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.default':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('core/iptables.erb'),
  }
  # syslog
  if ! defined(File['/etc/rsyslog.d/50-default.conf']) {
    file { '/etc/rsyslog.d/50-default.conf':
      alias   => 'core::config::default_syslog_conf',
      ensure  => present,
      content => template('core/rsyslog-50-default.conf.erb'),
      notify  => Service['rsyslog'],
    }
  }
  # collectd
  file { 'core::config::collectd_conf':
    ensure  => present,
    path    => '/etc/collectd/collectd.conf',
    content => template('core/collectd.conf.erb'),
    notify  => Service['collectd'],
    require => Package['collectd'],
  }
  # apt update
  cron { 'core::config::cron_apt_update':
    command   => 'apt-get update > /dev/null 2>&1',
    user      => root,
    hour      => '*',
    minute    => '05',
  }
}
