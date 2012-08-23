#!/usr/bin/env python
import socket
import sys
from optparse import OptionParser
import time
import json
from datetime import datetime

def send(server='irc.freenode.net', port=6667, channel=None, nick='sensubot'):
    text = sys.stdin.read()
    # attempt to parse sensu message
    try:
        data = json.loads(text)
        host = data.get('client', {}).get('name')
        check_name = data.get('check', {}).get('name')
        check_action = data.get('action')
        timestamp = data.get('check', {}).get('issued')
        check_date = datetime.fromtimestamp(int(timestamp)).strftime('%Y-%m-%d %H:%M:%S')
        check_output = data.get('check', {}).get('output')
        text = '{0}: {1} ({2}) at {3}: {4}'.format(host, check_name, \
            check_action, check_date, check_output)
    except Exception, e:
        text = str(e)
    ircsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    ircsock.connect((server, int(port)))
    ircsock.send('USER {0} 8 * : {0}\n'.format(nick))
    ircsock.send('NICK {0}\r\n'.format(nick))
    ircsock.send('JOIN {0}\r\n'.format(channel))
    while True:
        resp = ircsock.recv(2048).strip('\r\n')
        if resp.find(channel) > -1:
            break
        time.sleep(2)
    ircsock.send('PRIVMSG {0} :{1}\n'.format(channel, text))
    ircsock.close()

if __name__=='__main__':
    op = OptionParser()
    op.add_option('-s', action='store', dest='server', default='irc.freenode.net')
    op.add_option('-p', action='store', dest='port', default=6667)
    op.add_option('-c', action='store', dest='channel', default='sensubot')
    op.add_option('-n', action='store', dest='nick', default='sensubot')
    opts, args = op.parse_args()
    send(opts.server, opts.port, opts.channel, opts.nick)
    sys.exit(0)
