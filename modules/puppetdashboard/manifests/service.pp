class puppetdashboard::service {
  service { "puppet-dashboard-workers":
    ensure  => running,
    provider  => 'upstart',
    require => Package["puppet-dashboard"],
    subscribe => [
      File['/usr/share/puppet-dashboard/config/settings.yml'],
    ],
  }
}
