class solr::config inherits solr::params {
  $iptables_hosts = $solr::params::iptables_hosts
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # only configure solr if specified
  if ($solr::configure) {
    exec { 'solr::config::update_supervisor':
      command     => 'supervisorctl update',
      refreshonly => true,
    }
    # supervisor config for solr
    file { '/etc/supervisor/conf.d/solr.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      content => template('solr/solr.conf'),
      notify  => Exec['solr::config::update_supervisor'],
    }
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.solr':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('solr/iptables.erb'),
  }
}
