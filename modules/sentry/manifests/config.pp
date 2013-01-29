class sentry::config inherits sentry::params {
  $iptables_hosts = $sentry::params::iptables_hosts
  $sentry_db_engine = $sentry::params::sentry_db_engine
  $sentry_db_host = $sentry::params::sentry_db_host
  $sentry_db_port = $sentry::params::sentry_db_port
  $sentry_db_name = $sentry::params::sentry_db_name
  $sentry_db_user = $sentry::params::sentry_db_user
  $sentry_db_password = $sentry::params::sentry_db_password
  $sentry_url_prefix = $sentry::params::sentry_url_prefix
  $sentry_key = $sentry::params::sentry_key
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # sentry conf
  file { '/etc/sentry.conf.py':
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0640,
    content   => template('sentry/sentry.conf.py.erb'),
  }
  # db setup ; only supporting postgres at the moment
  if $sentry_db_engine == 'postgresql_psycopg2' {
    exec { 'sentry::config::create_user':
      command   => "createuser -S -D -R -e ${sentry_db_user}",
      user      => 'postgres',
      unless    => "echo 'select usename from pg_user;' | psql | grep ${sentry_db_user}",
      notify    => Exec['sentry::config::set_password'],
    }
    exec { 'sentry::config::set_password':
      command     => "echo \"alter user ${sentry_db_user} with password '${sentry_db_password}'\" | psql",
      user        => 'postgres',
      refreshonly => true,
    }
    exec { 'sentry::config::create_db':
      command   => "createdb -E utf8 ${sentry_db_name} -T template0 -O ${sentry_db_user}",
      user      => 'postgres',
      unless    => "echo '\\list' | psql | grep ${sentry_db_name}",
      require   => Exec['sentry::config::create_user'],
      notify    => Exec['sentry::config::init_db'],
    }
    exec { 'sentry::config::init_db':
      command     => 'sentry --config=/etc/sentry.conf.py upgrade --noinput',
      user        => root,
      refreshonly => true,
      require     => [ Exec['sentry::config::create_user'], Exec['sentry::config::set_password'], File['/etc/sentry.conf.py'] ],
      notify      => Exec['sentry::config::create_sentry_admin'],
    }
    exec { 'sentry::config::create_sentry_admin':
      command     => 'sentry --config=/etc/sentry.conf.py createsuperuser --username=admin --email=admin@localhost.local --noinput',
      user        => root,
      refreshonly => true,
      notify      => Exec['sentry::config::sentry_admin_password'],
    }
    exec { 'sentry::config::sentry_admin_password':
      command     => "echo \"from django.contrib.auth.models import User ; u = User.objects.get(username='admin'); u.set_password('sentry'); u.save();\" | sentry --config=/etc/sentry.conf.py shell",
      user        => root,
      refreshonly => true,
      require     => Exec['sentry::config::create_sentry_admin'],
    }
  }
  file { '/etc/supervisor/conf.d/sentry-http.conf':
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0644,
    content   => template('sentry/supervisor.http.conf.erb'),
    require   => Package['supervisor'],
    notify    => Exec['sentry::config::update_supervisor'],
  }
  file { '/etc/supervisor/conf.d/sentry-udp.conf':
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0644,
    content   => template('sentry/supervisor.udp.conf.erb'),
    require   => Package['supervisor'],
    notify    => Exec['sentry::config::update_supervisor'],
  }
  exec { 'sentry::config::update_supervisor':
    command     => 'supervisorctl update',
    user        => root,
    refreshonly => true,
  }
  # iptables
  file { '/tmp/.arcus.iptables.rules.sentry':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    content => template('sentry/iptables.erb'),
  }
}
