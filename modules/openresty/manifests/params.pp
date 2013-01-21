class openresty::params {
  $iptables_hosts = hiera_array('openresty_iptables_hosts', ['0.0.0.0/0'])
  $openresty_url = 'http://agentzh.org/misc/nginx/ngx_openresty-1.2.4.13.tar.gz'
  $luasocket_url = 'http://files.luaforge.net/releases/luasocket/luasocket/luasocket-2.0.2/luasocket-2.0.2.tar.gz'
}
