class sentry::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  $sentry_db_engine = $sentry::params::sentry_db_engine
  if ! defined(Package['python-setuptools']) {
    package { 'python-setuptools':
      ensure  => installed,
    }
  }
  if ! defined(Package['supervisor']) { package { 'supervisor': ensure  => installed, } }
  # install pip
  exec { 'sentry::package::install_pip':
    command   => 'easy_install pip',
    user      => root,
    unless    => 'test -e /usr/local/bin/pip',
  }
  # install virtualenv
  exec { 'sentry::package::install_virtualenv':
    command   => 'pip install virtualenv',
    user      => root,
    unless    => 'test -e /usr/local/bin/virtualenv',
    require   => Exec['sentry::package::install_pip'],
  }
  # install sentry
  exec { 'sentry::package::install_sentry':
    command   => 'pip install sentry',
    user      => root,
    unless    => 'test -e /usr/local/bin/sentry',
    require   => Exec['sentry::package::install_pip'],
  }
  # install eventlet
  exec { 'sentry::package::install_eventlet':
    command   => 'pip install eventlet',
    user      => root,
    unless    => "python -c 'import eventlet'",
    require   => [ Exec['sentry::package::install_pip'] ],
  }
  # install db support
  if $sentry_db_engine == 'postgresql_psycopg2' {
    if ! defined(Package['postgresql']) { package { 'postgresql': ensure  => installed, } }
    if ! defined(Package['libpq-dev']) { package { 'libpq-dev': ensure  => installed, } }
    exec { 'sentry::package::install_psycopg2':
      command   => 'pip install psycopg2',
      user      => root,
      unless    => "python -c 'import psycopg2'",
      require   => [ Exec['sentry::package::install_pip'], Package['libpq-dev'] ],
    }
  }
}
