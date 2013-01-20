#!/usr/bin/env python
import sys
from redis import Redis
data = {
    'apache2_iptables_hosts': ['0.0.0.0'],
    'arcus_api_key': 'arcus-default-key',
    'arcus_api_url': 'https://nucleo.arcus.io/api/v1',
    'arcus_iptables_hosts': ['0.0.0.0'],
    'collectd_host': 'localhost',
    'collectd_port': '25826',
    'graphite_iptables_hosts': ['0.0.0.0'],
    'graylog_iptables_hosts': ['0.0.0.0'],
    'graylog_external_hostname': 'localhost',
    'graylog_server_name': 'localhost',
    'memcached_iptables_hosts': ['0.0.0.0'],
    'memcached_memory_limit': '64',
    'memcached_user': 'memcache',
    'memcached_listen_host': '127.0.0.1',
    'memcached_port': '11211',
    'memcached_connection_limit': '1024',
    'memcached_log': '/var/log/memcached.log',
    'mongodb_auth_enabled': 'false',
    'mongodb_db_path': '/var/lib/mongodb',
    'mongodb_port': '27017',
    'mongodb_log_file': '/var/log/mongodb/mongodb.log',
    'mongodb_replica_set': 'nil',
    'mongodb_iptables_hosts': ['0.0.0.0'],
    'module_dirs': [],
    'mysql_root_password': 'root',
    'mysql_iptables_hosts': ['0.0.0.0'],
    'nginx_iptables_hosts': ['0.0.0.0'],
    'openresty_iptables_hosts': ['0.0.0.0'],
    'postfix_iptables_hosts': ['0.0.0.0'],
    'postgresql_iptables_hosts': ['0.0.0.0'],
    'puppet_dashboard_db_name': 'dashboard',
    'puppet_dashboard_db_username': 'dashboard',
    'puppet_dashboard_db_password': 'd@5hB0ard',
    'puppet_dashboard_url': 'http://puppet.local:3000',
    'puppet_dashboard_iptables_hosts': ['0.0.0.0'],
    'rabbitmq_user': 'rmquser',
    'rabbitmq_password': 'rmqpassword',
    'rabbitmq_iptables_hosts': ['0.0.0.0'],
    'redis_iptables_hosts': ['0.0.0.0'],
    'redis_listen_host': '127.0.0.1',
    'redis_port': '6379',
    'redis_timeout': '300',
    'redis_log_level': 'notice',
    'redis_databases': '16',
    'redis_user': 'redis',
    'redis_password': 'nil',
    'redis_data_dir': '/opt/redis',
    'redis_log_dir': '/var/log/redis',
    'sensu_alert_title': 'Sensu Alert',
    'sensu_alert_to_address': 'root@localhost',
    'sensu_alert_from_address': 'sensu@arcus.io',
    'sensu_iptables_hosts': ['0.0.0.0'],
    'sensu_rabbitmq_host': 'localhost',
    'sensu_rabbitmq_port': '5672',
    'sensu_rabbitmq_vhost': '/sensu',
    'sensu_rabbitmq_user': 'sensu',
    'sensu_rabbitmq_pass': 's3n5u',
    'sensu_redis_host': 'localhost',
    'sensu_redis_port': '6379',
    'sensu_api_host': 'localhost',
    'sensu_api_port': '4567',
    'sensu_dashboard_host': 'localhost',
    'sensu_dashboard_port': '8080',
    'sensu_dashboard_user': 'admin',
    'sensu_dashboard_pass': 'sensu',
    'solr_iptables_hosts': ['0.0.0.0'],
    'syslog_server': 'localhost',
    'use_nucleo_enc': 'true',
}

def main(host=None, port=None, db=0, password=None):
    rds = Redis(host=host, port=port, db=db, password=password)
    key_base = 'hiera:common:{0}'
    for k,v in data.iteritems():
        # only add key if doesn't exist
        if not rds.keys(key_base.format(k)):
            if isinstance(v, str):
                rds.set(key_base.format(k), v)
            elif isinstance(v, list):
                for x in v:
                    rds.sadd(key_base.format(k), x)
            else:
                print('Unknown data type ; skipping key: {0}'.format(k))

if __name__=='__main__':
    from optparse import OptionParser
    op = OptionParser()
    op.add_option('--host', action='store', dest='host', default='127.0.0.1')
    op.add_option('--port', action='store', dest='port', type='int', default=6379)
    op.add_option('--db', action='store', dest='db')
    op.add_option('--password', action='store', dest='password')
    opts, args = op.parse_args()
    main(opts.host, opts.port, opts.db, opts.password)
    sys.exit(0)

