class uwsgi::package inherits uwsgi::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package["libxslt-dev"]) { package { "libxslt-dev": ensure => installed, } }
  if ! defined(Package["libxml2-dev"]) { package { "libxml2-dev": ensure => installed, } }
  if ! defined(Package["libssl-dev"]) { package { "libssl-dev": ensure => installed, } }
  if ! defined(Package["python-dev"]) { package { "python-dev": ensure => installed, } }
  if ! defined(Package["python-setuptools"]) { package { "python-setuptools": ensure => installed, } }
  if ! defined(Package["supervisor"]) { package { "supervisor": ensure => installed, } }
  # install pip
  exec { 'uwsgi::package::install_pip':
    command   => 'easy_install pip',
    user      => root,
    unless    => 'test -e /usr/local/bin/pip',
    require   => Package['python-setuptools'],
  }
  exec { 'uwsgi::package::install_uwsgi':
    cwd     => '/tmp',
    command => 'pip install uwsgi',
    unless  => 'test -d /usr/local/bin/uwsgi',
    require  => [ 
      Package['libxslt-dev'],
      Package['libxml2-dev'],
      Package['libssl-dev'],
      Package['python-dev'],
      Exec['uwsgi::package::install_pip'],
    ],
  }
}
