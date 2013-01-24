#!/bin/sh

# common config

if [ -e "/etc/.configured" ] ; then
    echo "VM appears configured ; not provisioning"
    exit 0
fi

# configure local hosts
if [ "`grep util /etc/hosts`" = "" ]; then
    echo "10.10.10.26 util.local" >> /etc/hosts
fi
if [ "`grep "puppet.local" /etc/hosts`" = "" ] ; then
    echo "10.10.10.25 puppet puppet.local" >> /etc/hosts
fi

# puppetlabs repo
if [ ! -e "/etc/apt/sources.list.d/puppetlabs.list" ] ; then
    wget -q "http://apt.puppetlabs.com/puppetlabs-release-precise.deb" -O /tmp/puppetlabs.deb
    dpkg -i /tmp/puppetlabs.deb
fi

# update apt
apt-get -y update 2>&1 > /dev/null
apt-get -y install vim screen python-setuptools python-dev
easy_install pip > /dev/null 2>&1

if [ "`grep 'util.local' /etc/hosts`" = "" ] ; then
    echo "10.10.10.25 puppet puppet.local\n10.10.10.26 util.local\n10.10.10.27 sandbox.local\n" >> /etc/hosts
fi

CWD=$PWD
if [ "`hostname`" = "puppet.local" ] ; then
    echo "Configuring Puppet master"
    DEBIAN_FRONTEND=noninteractive apt-get install -y puppetmaster-passenger puppet-dashboard mysql-server redis-server
    # configure puppet autosigning
    echo "*.local" > /etc/puppet/autosign.conf
    # setup dashboard db
    echo "create database dashboard character set utf8;" | mysql -u root
    echo "create user dashboard@'localhost' identified by 'd@5hB0ard';" | mysql -u root
    echo "grant all on dashboard.* to dashboard@'%';" | mysql -u root
    cd $CWD
    echo "
production:
  database: dashboard
  username: dashboard
  password: d@5hB0ard
  encoding: utf8
  adapter: mysql
" >     /usr/share/puppet-dashboard/config/database.yml
    # migrate
    cd /usr/share/puppet-dashboard ; RAILS_ENV=production rake db:migrate 2>&1
    # enable dashboard
    sed -i 's/.*START.*/START=yes/g' /etc/default/puppet-dashboard
    sed -i 's/.*START.*/START=yes/g' /etc/default/puppet-dashboard-workers
    # hiera
    gem install --no-ri --no-rdoc hiera hiera-puppet redis hiera-redis hiera-redis-backend
    ln -sf /mnt/hgfs/arcus-puppet/auth.conf /etc/puppet/auth.conf
    ln -sf /mnt/hgfs/arcus-puppet/hiera.yaml /etc/hiera.yaml
    # hiera defaults
    pip install redis
    echo "Loading Hiera defaults into Redis"
    python /vagrant/hiera.redis.py
    # configure init script (hangs over ssh)
    sed -i 's/.*start-stop-daemon --start.*/DASHBOARD_CMD=\"${DASHBOARD_RUBY} ${DASHBOARD_HOME}\/script\/server -e ${DASHBOARD_ENVIRONMENT} -p ${DASHBOARD_PORT} -b ${DASHBOARD_IFACE} -d\"\n\tsu -s \/bin\/sh -c "${DASHBOARD_CMD}" ${DASHBOARD_USER}\n\tlocal PID=$(pgrep -f "${DASHBOARD_CMD}")\n\techo $PID > ${PIDFILE}/g' /etc/init.d/puppet-dashboard
    # set sandbox values for hiera
    echo "set hiera:common:graylog_server_name util.local" | redis-cli
    echo "set hiera:common:collectd_host util.local" | redis-cli
    echo "set hiera:common:sensu_rabbitmq_host util.local" | redis-cli
    echo "set hiera:common:sensu_redis_host util.local" | redis-cli
    echo "set hiera:common:sensu_api_host util.local" | redis-cli
    echo "set hiera:common:sensu_dashboard_host util.local" | redis-cli
    echo "set hiera:common:syslog_server util.local" | redis-cli
    /etc/init.d/puppet-dashboard start 
    /etc/init.d/puppet-dashboard-workers start
else
    echo "Configuring client"

    apt-get install -y puppet-common
    # create the initial puppet.conf ; needed to sync puppet role facts
    mkdir -p /etc/puppet
    echo "[main]\n  pluginsync = true\n  ssldir = /etc/puppet/ssl\n" > /etc/puppet/puppet.conf
    # run the initial sync in the foreground
    puppet agent -t

fi

# mark instance as configured
touch /etc/.configured
echo "Configuration complete."

exit 0
