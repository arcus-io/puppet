# Arcus Puppet
This is the repository for the Arcus Cloud puppet configuration management.

## Master
To setup a Puppet master:
  * Install Puppet (via the PuppetLabs repos)
  * Install Hiera and Hiera-Puppet (`gem install hiera hiera-puppet`)
    * Restart Puppet Master (or Apache2 if using puppetmaster-passenger)
  * Clone the Arcus puppet repository to `/opt/arcus`
  * Symlink `/opt/arcus/manifests` to `/etc/puppet/manifests`
  * Clone the Hiera repo (http://github.com/puppetlabs/hiera-puppet.git) to `/etc/puppet/modules/hiera-puppet`
  * Symlink `/opt/arcus/auth.conf` to `/etc/puppet/auth.conf` (for Puppet)
  * Copy `/opt/arcus/puppet.conf` to `/etc/puppet/puppet.conf` (for Puppet) -- no symlink ; file is managed with Puppet
  * Symlink `/opt/arcus/hiera.yaml` to `/etc/hiera.yml` (for the Hiera CLI) and `/etc/puppet/hiera.yaml` (for Puppet)
  * Symlink `/opt/arcus/common.yaml` to `/etc/puppet/hiera/common.yaml`
  * TODO: Clone the Hiera private configs to `/etc/puppet/hiera/`
  * Restart Puppet Master

If using Redis as Hiera Backend:
  * Install Redis and Hiera-Redis gems:
    * `gem install redis`
    * `gem install hiera-redis`
  * Install the default common Hiera config into Redis:
    * `python hiera.redis.py -h` for instructions

## Using Nucleo as ENC
To use Nucleo as an external node classifer (ENC) ** make sure Nucleo is running and node is registered:
  * Edit `/etc/puppet/puppet.conf` to use `/opt/arcus/external_node` -- see `puppet.conf` for and example
