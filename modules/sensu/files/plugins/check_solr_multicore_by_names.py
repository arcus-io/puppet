#! /usr/bin/python
#
'''
Project     :       Apache Solr Health Check
Version     :       0.1
Author      :       Ashok Raja R <ashokraja.linux@gmail.com>
Summary     :       This program is a nagios plugin that checks Apache Solr Health
Dependency  :       Linux/nagios/Python-2.6

Usage :
```````
shell> python check_solr.py
'''

#-----------------------|
# Import Python Modules |
#-----------------------|
import os, sys, urllib
from xml.dom import minidom
from optparse import OptionParser

#--------------------------|
# Main Program Starts Here |
#--------------------------|
# Command Line Arguments Parser
cmd_parser = OptionParser(version="%prog 0.1-multicore-bynames")
cmd_parser.add_option("-q", "--qps", action="store_true", dest="qps", help="Get QPS information of the SOLR Server")
cmd_parser.add_option("-r", "--requesttime", action="store_true", dest="tpr", help="Get Average Time Per Requests")
cmd_parser.add_option("-u", "--updatetime", action="store_true", dest="tpu", help="Get Average Time Per Update")
cmd_parser.add_option("-d", "--doc", action="store_true", dest="doc", help="Get Docs information of the SOLR Server", default=True)
cmd_parser.add_option("-H", "--host", type="string", action="store", dest="solr_server", help="SOLR Server IPADDRESS")
cmd_parser.add_option("-p", "--port", type="string", action="store", dest="solr_server_port", help="SOLR Server port")
cmd_parser.add_option("-C", "--core", type="string", action="store", dest="solr_core", help="SOLR core")
cmd_parser.add_option("-w", "--warning", type="float", action="store", dest="warning_per", help="Exit with WARNING status if higher than the PERCENT of CPU Usage", metavar="Warning Percentage")
cmd_parser.add_option("-c", "--critical", type="float", action="store", dest="critical_per", help="Exit with CRITICAL status if higher than the PERCENT of CPU Usage", metavar="Critical Percentage")
(cmd_options, cmd_args) = cmd_parser.parse_args()
# Check the Command syntax
if not (cmd_options.warning_per and cmd_options.critical_per and cmd_options.solr_server and cmd_options.solr_server_port):
    cmd_parser.print_help()
    sys.exit(3)

# Collect Solr Statistics Object
class CollectStat:
    ''' Obejct to Collect the Statistics from the 'n'th Element of the XML Data'''
    def __init__(self,n):
        self.stats = {}
        solr_path =  '/solr/' + cmd_options.solr_core + '/admin/stats.jsp' if cmd_options.solr_core else '/solr/admin/stats.jsp'
        solr_all_stat = minidom.parseString(urllib.urlopen('http://' + cmd_options.solr_server + ':' + cmd_options.solr_server_port + solr_path).read())
        for stat in solr_all_stat.getElementsByTagName('entry')[n].getElementsByTagName("stat"):
            self.stats[stat.getAttribute('name')] = stat.childNodes[0].data.strip()

# Collect stats by entry name
class CollectStatByName:
    ''' Object to Collect the Statistics by XML entry name'''
    def __init__(self,target_entry_name):
        self.stats = {}
        solr_path =  '/solr/' + cmd_options.solr_core + '/admin/stats.jsp' if cmd_options.solr_core else '/solr/admin/stats.jsp'
        solr_all_stat = minidom.parseString(urllib.urlopen('http://' + cmd_options.solr_server + ':' + cmd_options.solr_server_port + solr_path).read())
        
        for entry in solr_all_stat.getElementsByTagName('entry'):
            entry_name_elements = entry.getElementsByTagName('name')
            entry_name_element = entry_name_elements[0]
            entry_name = entry_name_element.childNodes[0].data.strip()
    
            if entry_name == target_entry_name :
                for stat in entry.getElementsByTagName("stat"):
                    self.stats[stat.getAttribute('name')] = stat.childNodes[0].data.strip()

# Check QPS
if cmd_options.qps :
    # Get the QPS Statistics
    solr_qps_stats = CollectStatByName('standard')
    avgRequestsPerSecond = float(solr_qps_stats.stats['avgRequestsPerSecond'])
    requests = int(solr_qps_stats.stats['requests'])
    
    msg = "%.2f requests per second | ReqPerSec=%.2f requests=%ic" % (avgRequestsPerSecond, avgRequestsPerSecond, requests)
    
    if avgRequestsPerSecond >= cmd_options.critical_per:
        print "SOLR QPS CRITICAL : %s" % (msg)
        sys.exit(2)
    elif avgRequestsPerSecond >= cmd_options.warning_per:
        print "SOLR QPS WARNING : %s" % (msg)
        sys.exit(1)
    else:
        print "SOLR QPS OK : %s" % (msg)
        sys.exit(0)
# Check Average Response Time
elif cmd_options.tpr :
    solr_tpr_stats = CollectStatByName('standard')
    avgTimePerRequest = float(solr_tpr_stats.stats['avgTimePerRequest'])
    requests = int(solr_tpr_stats.stats['requests'])
    
    msg = "%.2f msecond response time | AvgRes=%.2fms requests=%ic" % (avgTimePerRequest, avgTimePerRequest, requests)
    
    if avgTimePerRequest >= float(cmd_options.critical_per):
        print "SOLR AvgRes CRITICAL : %s" % (msg)
        sys.exit(2)
    elif avgTimePerRequest >= float(cmd_options.warning_per):
        print "SOLR AvgRes WARNING : %s" % (msg)
        sys.exit(1)
    else:
        print "SOLR AvgRes OK : %s" % (msg)
        sys.exit(0)
# Check Average Update Time
elif cmd_options.tpu :
    solr_tpu_stats = CollectStatByName('/update')
    avgTimePerUpdate = float(solr_tpu_stats.stats['avgTimePerRequest'])
    
    msg = "%.2f msecond update time | AvgUpdate=%.2fms" % (avgTimePerUpdate, avgTimePerUpdate)
    
    if avgTimePerUpdate >= float(cmd_options.critical_per):
        print "SOLR AvgRes CRITICAL : %s" % (msg)
        sys.exit(2)
    elif avgTimePerUpdate >= float(cmd_options.warning_per):
        print "SOLR AvgRes WARNING : %s" % (msg)
        sys.exit(1)
    else:
        print "SOLR AvgRes OK : %s" % (msg)
        sys.exit(0)
# Check Docs
elif cmd_options.doc :
    # Get the Documents Statistics
    solr_doc_stats = CollectStatByName('searcher')
    numDocs = int(solr_doc_stats.stats['numDocs'])
    maxDoc = int(solr_doc_stats.stats['maxDoc'])
    
    msg = "%d Total Documents | warn: %d critical: %d" % (numDocs,
        cmd_options.warning_per, cmd_options.critical_per)
    
    if numDocs <= int(cmd_options.warning_per):
        print "SOLR DOCS WARNING : %s" % (msg)
        sys.exit(1)
    elif numDocs <= int(cmd_options.critical_per):
        print "SOLR DOCS CRITICAL : %s" % (msg)
        sys.exit(2)
    else:
        print "SOLR DOCS OK : %s" % (msg)
        sys.exit(0)
else:
    sys.exit(3)
