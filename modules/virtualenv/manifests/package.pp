class virtualenv::package inherits virtualenv::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package["python-dev"]) { package { "python-dev": ensure => installed, } }
  if ! defined(Package["python-setuptools"]) { package { "python-setuptools": ensure => installed, } }
  # install pip
  exec { 'virtualenv::package::install_pip':
    command   => 'easy_install pip',
    user      => root,
    unless    => 'test -e /usr/local/bin/pip',
    require   => Package['python-setuptools'],
  }
  exec { 'virtualenv::package::install_virtualenv':
    cwd     => '/tmp',
    command => 'pip install virtualenv',
    unless  => 'test -e /usr/local/bin/virtualenv',
    require  => [ 
      Package['python-dev'],
      Exec['virtualenv::package::install_pip'],
    ],
  }
}
