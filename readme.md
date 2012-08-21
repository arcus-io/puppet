# Arcus Puppet
This is the repository for the Arcus Cloud puppet configuration management.

## Master
To setup a Puppet master:
  * Install Puppet (via the PuppetLabs repos)
  * Clone the Arcus puppet repository to `/opt/arcus`
  * Symlink `/opt/arcus/manifests` to `/etc/puppet/manifests`
  * Copy the `/opt/arcus/puppet.conf` to `/etc/puppet/puppet.conf`
  * Clone the Hiera repo (http://github.com/puppetlabs/hiera-puppet.git) to `/etc/puppet/modules/hiera-puppet`
  * TODO: Clone the Hiera private configs to `/etc/puppet/hiera/`
