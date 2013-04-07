class solr::package inherits solr::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package['supervisor']) { package { 'supervisor': ensure => installed, } }
  if ! defined(Package['openjdk-7-jdk']) { package { 'openjdk-7-jdk': ensure => installed, } }
  if ! defined(Package['openjdk-7-jre-headless']) { package { 'openjdk-7-jre-headless': ensure => installed, } }
  exec { 'solr::package::install_solr':
    cwd     => '/opt',
    command => "wget ${solr::params::solr_url} -O /tmp/solr.tar.gz ; tar zxf /tmp/solr.tar.gz ; mv /opt/*solr* /opt/solr",
    unless  => 'test -d /opt/solr',
    timeout => 1800,
    require  => [ 
      Package['openjdk-7-jdk'],
      Package['openjdk-7-jre-headless'],
    ],
    notify  => Exec['solr::package::configure'],
  }
  exec { 'solr::package::configure':
    cwd         => '/opt/',
    command     => 'cp -rf solr/example solr/default',
    require     => Exec['solr::package::install_solr'],
    refreshonly => true,
  }
}
