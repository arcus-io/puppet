#!/usr/bin/env python

# Check CloudWatch stats for RDS instances.
#
# Requirements:
# - Boto (http://boto.s3.amazonaws.com/index.html)
#

from datetime import datetime, timedelta
import sys
from optparse import OptionParser
from boto.ec2.cloudwatch import CloudWatchConnection

def get_stats(key, secret, db_id, metric):
    end = datetime.now()
    start = end - timedelta(minutes=5)
    conn = CloudWatchConnection(key, secret)
    try:
        res = conn.get_metric_statistics(60, start, end, metric,
            "AWS/RDS", "Average", {"DBInstanceIdentifier": db_id})
    except Exception, e:
        print(e)
        sys.exit(1)
    average = res[-1]["Average"]
    return average

if __name__=='__main__':
    parser = OptionParser()
    parser.add_option("-i", "--instance-id", dest="instance_id",
        help="DBInstanceIdentifier")
    parser.add_option("-a", "--access-key", dest="access_key",
        help="AWS Access Key")
    parser.add_option("-k", "--secret-key", dest="secret_key",
        help="AWS Secret Access Key")
    parser.add_option("-m", "--metric", dest="metric",
        help="Cloudwatch metric")
    parser.add_option("-n", "--nagios", dest="nagios", action='store_true',
        default=False, help="Format for Nagios")
    parser.add_option("-w", "--warning", dest="warning",
        help="Nagios warning level")
    parser.add_option("-c", "--critical", dest="critical",
        help="Nagios critical level")

    (options, args) = parser.parse_args()
    if not options.instance_id:
        parser.error('You must specify a DB Instance')
    if not options.access_key:
        parser.error('You must specify an AWS access key')
    if not options.secret_key:
        parser.error('You must specify an AWS secret key')
    if not options.metric:
        parser.error('You must specify a Cloudwatch metric name')

#metrics = {"CPUUtilization":{"type":"float", "value":None},
#    "ReadLatency":{"type":"float", "value":None},
#    "DatabaseConnections":{"type":"int", "value":None},
#    "FreeableMemory":{"type":"float", "value":None},
#    "ReadIOPS":{"type":"int", "value":None},
#    "WriteLatency":{"type":"float", "value":None},
#    "WriteThroughput":{"type":"float", "value":None},
#    "WriteIOPS":{"type":"int", "value":None},
#    "SwapUsage":{"type":"float", "value":None},
#    "ReadThroughput":{"type":"float", "value":None},
#    "FreeStorageSpace":{"type":"float", "value":None}}
    
    stats = get_stats(options.access_key, options.secret_key,
        options.instance_id, options.metric)
    # format for nagios
    if options.nagios:
        status = 'OK'
        if float(str(stats)) >= float(options.warning):
            status = 'WARNING'
        if float(str(stats)) >= float(options.critical):
            status = 'CRITICAL'
        print('{0} {1}: {2}'.format(options.metric, status, stats))
    else:
        print(stats)
