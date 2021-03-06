class iptables::post_config inherits iptables::params {
  Exec {
    path      => "${::path}",
    logoutput => on_failure,
  }
  # compile iptables
  exec { 'iptables::post_config::build_iptables_rules':
    cwd       => '/tmp',
    command   => 'echo "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" > .arcus.iptables ; cat ./.arcus.iptables.rules* >> .arcus.iptables ; echo "iptables -A INPUT -j DROP" >> .arcus.iptables',
    onlyif    => 'ls -lah | grep arcus.iptables.rules.*',
  }
  exec { 'iptables::post_config::apply_iptables_rules':
    cwd       => '/tmp',
    command   => 'iptables -F ; /bin/sh /tmp/.arcus.iptables',
    user      => root,
    require   => Exec['iptables::post_config::build_iptables_rules'],
  }
}
