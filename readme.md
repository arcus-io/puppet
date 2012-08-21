# Arcus Puppet
This is the repository for the Arcus Cloud puppet configuration management.

## Master
To setup a Puppet master:
  * Install Puppet (via the PuppetLabs repos)
  * Clone the Arcus puppet repository to `/opt/arcus`
  * Symlink `/opt/arcus/manifests` to `/etc/puppet/manifests`
  * Copy the `/opt/arcus/puppet.conf` to `/etc/puppet/puppet.conf`
  * Clone the Hiera repo (http://github.com/puppetlabs/hiera-puppet.git) to `/etc/puppet/modules/hiera-puppet`
  * Symlink `/opt/arcus/hiera.yaml` to `/etc/hiera.yml` (for the Hiera CLI) and `/etc/puppet/hiera.yaml` (for Puppet)
  * Symlink `/opt/arcus/common.yaml` to `/etc/puppet/hiera/common.yaml`
  * TODO: Clone the Hiera private configs to `/etc/puppet/hiera/`
