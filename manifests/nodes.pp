node basenode {
  include arcus
}
node default inherits basenode {} # default for all non-defined nodes

node puppet inherits basenode {
  class { 'puppetdashboard': }
  # custom subscribe to restart apache (passenger) on puppet.conf changes
  service { "apache2":
    ensure    => running,
    subscribe => File["base::config::puppet_conf"],
  }
}

