# Arcus Puppet
This is the repository for the Arcus Cloud puppet configuration management.

## Master
To setup a Puppet master:
  * Install Puppet (via the PuppetLabs repos)
    * `apt-get install -y puppetmaster-passenger puppetdb puppetdb-terminus`
  * Install Hiera and Hiera-Puppet (`gem install hiera hiera-puppet`)
    * Restart Puppet Master (or Apache2 if using puppetmaster-passenger)
  * Clone the Arcus puppet repository to `/opt/arcus`
  * Symlink `/opt/arcus/manifests` to `/etc/puppet/manifests`
  * Symlink `/opt/arcus/auth.conf` to `/etc/puppet/auth.conf` (for Puppet)
  * Copy `/opt/arcus/puppet.conf` to `/etc/puppet/puppet.conf` (for Puppet) -- no symlink ; file is managed with Puppet
  * Symlink `/opt/arcus/hiera.yaml` to `/etc/hiera.yml` (for the Hiera CLI) and `/etc/puppet/hiera.yaml` (for Puppet)
  * Symlink `/var/lib/puppet/ssl` to `/etc/puppet/ssl` (remove existing `/var/lib/puppet/ssl` dir first)
  * Restart Puppet Master

If using Redis as Hiera Backend:
  * Install Redis and Hiera-Redis gems:
    * `gem install redis`
    * `gem install hiera-redis hiera-redis-backend`
  * Install the default common Hiera config into Redis:
    * `python hiera.redis.py -h` for instructions

## Using Nucleo as ENC
To use Nucleo as an external node classifer (ENC) ** make sure Nucleo is running and node is registered:
  * Edit `/etc/puppet/puppet.conf` to use `/opt/arcus/external_node` -- see `puppet.conf` for and example

# Vagrant
The easiest way to get a functioning development setup is to use [Vagrant](http://www.vagrantup.com/).  A multi-vm setup is provided and will setup a complete Puppet, Puppet Dashboard, and Puppet DB environment.

## Puppet Master
To launch a puppet master:

`vagrant up puppetmaster`

This will launch a VM and configure Puppet.  Use the following links to access the dashboard services:

* Puppet Dashboard: [http://localhost:3000](http://localhost:3000)
* Puppet DB Dashboard: [http://localhost:8080](http://localhost:8080)

To launch a node, use either the util or sandbox definitions.

`vagrant up sandbox`

This will launch a VM and automatically provision with the Puppet master.  You can then
use the Puppet Dashboard to create classes and attach those to nodes.  On next
refresh, the node will apply those modules.
