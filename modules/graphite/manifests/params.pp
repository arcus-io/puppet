class graphite::params {
  $iptables_hosts = hiera_array('graphite_iptables_hosts', ['0.0.0.0'])
  $whisper_url = 'http://launchpad.net/graphite/0.9/0.9.9/+download/whisper-0.9.9.tar.gz'
  $carbon_url = 'http://launchpad.net/graphite/0.9/0.9.9/+download/carbon-0.9.9.tar.gz'
  $graphite_web_url = 'http://launchpad.net/graphite/0.9/0.9.9/+download/graphite-web-0.9.9.tar.gz'
}
