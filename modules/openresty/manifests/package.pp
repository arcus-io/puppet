class openresty::package inherits openresty::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  if ! defined(Package["libreadline-dev"]) { package { "libreadline-dev": ensure => installed, } }
  if ! defined(Package["libncurses5-dev"]) { package { "libncurses5-dev": ensure => installed, } }
  if ! defined(Package["libpcre3-dev"]) { package { "libpcre3-dev": ensure => installed, } }
  if ! defined(Package["libssl-dev"]) { package { "libssl-dev": ensure => installed, } }
  if ! defined(Package["liblua5.1-dev"]) { package { "liblua5.1-dev": ensure => installed, } }
  if ! defined(Package["liblua5.1-socket2"]) { package { "liblua5.1-socket2": ensure => installed, } }
  if ! defined(Package["perl"]) { package { "perl": ensure => installed, } }
  exec { 'openresty::package::install_openresty':
    cwd     => '/tmp',
    command => "wget ${openresty::params::openresty_url} -O openresty.tar.gz ; tar zxf openresty.tar.gz ; cd ngx_* ; ./configure --with-luajit ; make -j2 install",
    unless  => 'test -d /usr/local/openresty',
    require  => [ 
      Package['libreadline-dev'],
      Package['libncurses5-dev'],
      Package['libpcre3-dev'],
      Package['libssl-dev'],
      Package['liblua5.1-socket2'],
      Package['perl'],
    ],
  }
  exec { 'openresty::package::install_luasocket':
    cwd     => '/tmp',
    command => "wget ${openresty::params::luasocket_url} -O luasocket.tar.gz; tar zxf luasocket.tar.gz ; cd luasocket*; LUAINC=-I/usr/local/openresty/luajit/include/luajit-2.0/ make ; make install",
    unless  => 'test -d /usr/local/share/lua/5.1/socket',
    require => Exec['openresty::package::install_openresty'],
  }

}
