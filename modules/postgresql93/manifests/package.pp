class postgresql93::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  file { '/etc/apt/sources.list.d/pg.list':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main',
    notify  => Exec['postgresql93::package::get_pg_repo_key'],
  }
  exec { 'postgresql93::package::get_pg_repo_key':
    command     => 'wget --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc |\
        apt-key add - ; apt-get update',
    user        => root,
    refreshonly => true,
  }
  if ! defined(Package['postgresql-9.3']) { 
    package { 'postgresql-9.3':
        ensure  => installed,
        require => Exec['postgresql93::package::get_pg_repo_key'],
    }
  }
  if ! defined(Package['libpq-dev']) {
    package { 'libpq-dev': 
        ensure  => installed,
        require => Exec['postgresql93::package::get_pg_repo_key'],
    }
  }
  if ! defined(Package['postgresql-contrib-9.3']) { 
    package { 'postgresql-contrib-9.3':
        ensure  => installed,
        require => Exec['postgresql93::package::get_pg_repo_key'],
    }
  }
  if ! defined(Package['pgbouncer']) { package { 'pgbouncer': ensure  => installed, } }
}
