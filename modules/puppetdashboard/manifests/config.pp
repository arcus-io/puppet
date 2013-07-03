class puppetdashboard::config inherits puppetdashboard::params {
  $iptables_hosts = $puppetdashboard::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }

  exec { "puppetdashboard::config::config_puppetlabs_repo":
    cwd     => "/tmp",
    command => "wget --quiet \"${puppetdashboard::params::puppetlabs_deb_url}\" -O puppetlabs.deb ; dpkg -i puppetlabs.deb",
    creates => "/etc/apt/sources.list.d/puppetlabs.list",
    notify  => Exec["puppetdashboard::config::update_apt"],
  }
  exec { "puppetdashboard::config::update_apt":
    command     => "apt-get -y update",
    user        => root,
    require     => Exec["puppetdashboard::config::config_puppetlabs_repo"],
    refreshonly => true,
  }
  file { "puppetdashboard::config::dashboard_default":
    path    => "/etc/default/puppet-dashboard",
    content => template("puppetdashboard/dashboard_default.erb"),
    owner   => "root",
    group   => "root",
    mode    => 0644,
  }
  file { "puppetdashboard::config::dashboard-workers_default":
    path    => "/etc/default/puppet-dashboard-workers",
    content => template("puppetdashboard/dashboard-workers_default.erb"),
    owner   => "root",
    group   => "root",
    mode    => 0644,
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.puppetdashboard':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('puppetdashboard/iptables.erb'),
  }
  # cron
  cron { 'puppetdashboard::config::purge_puppet_yaml':
    command => "cd /var/lib/puppet/reports ; find . -type f -mtime +7 -delete",
    user    => root,
    hour    => 8,
    minute  => 0,
  }
  cron { 'puppetdashboard::config::purge_dashboard':
    command => "cd /usr/share/puppet-dashboard && RAILS_ENV=production rake reports:prune upto=1 unit=wk",
    user    => root,
    hour    => 8,
    minute  => 0,
  }
}
