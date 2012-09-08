#!/usr/bin/env python
import sys
from redis import Redis
data = {
    'arcus_api_key': 'arcus-default-key',
    'arcus_api_url': 'http://10.10.10.2:5000/api/v1',
    'collectd_host': 'localhost',
    'collectd_port': '25826',
    'memcached_memory_limit': '64',
    'memcached_user': 'memcache',
    'memcached_listen_host': '127.0.0.1',
    'memcached_port': '11211',
    'memcached_connection_limit': '1024',
    'memcached_log': '/var/log/memcached.log',
    'mysql_root_password': 'root',
    'puppet_dashboard_url': 'http://puppet.local:3000',
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
    'syslog_server': 'localhost',
}

def main(host=None, port=None, db=0, password=None):
    rds = Redis(host=host, port=port, db=db, password=password)
    for k,v in data.iteritems():
        rds.set('hiera:common:{0}'.format(k), v)

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

