class sensu::client {
  require sensu::package

  service { 'sensu-client':
    enable    => true,
    ensure    => running,
    provider  => 'upstart',
    require   => Package['sensu'],
    subscribe => [ File['/etc/sensu/config.json'], File['/etc/sensu/conf.d/client.json'] ],
  }
}
