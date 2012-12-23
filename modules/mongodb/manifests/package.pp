class mongodb::package {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # get apt key
  exec { 'mongodb::package::apt_key':
    command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10',
    user    => root,
    unless  => 'apt-key list | grep -i 10gen',
  }
  file { '/etc/apt/sources.list.d/10gen.list':
    alias   => 'mongodb::package::apt_source_list',
    ensure  => present,
    content => "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen\n",
    owner   => root,
    notify  => Exec['mongodb::package::apt_update'],
    require => Exec['mongodb::package::apt_key'],
  }
  exec { 'mongodb::package::apt_update':
    command     => 'apt-get update',
    user        => root,
    refreshonly => true,
  }
  if ! defined(Package["mongodb-10gen"]) {
    package { "mongodb-10gen":
      ensure  => installed,
      require => [ File['mongodb::package::apt_source_list'], Exec['mongodb::package::apt_update'] ],
    }
  }
}
