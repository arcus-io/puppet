class puppetdashboard::service {
  service { "puppet-dashboard":
    ensure  => running,
    require => Package["puppet-dashboard"],
    subscribe => [
      File['/usr/share/puppet-dashboard/config/settings.yml'],
    ],
  }
  service { "puppet-dashboard-workers":
    ensure  => running,
    require => Package["puppet-dashboard"],
    subscribe => [
      File['/usr/share/puppet-dashboard/config/settings.yml'],
    ],
  }
}
