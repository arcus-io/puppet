#!/usr/bin/env python
import sys
import smtplib
from optparse import OptionParser
from email.mime.text import MIMEText
import json
from datetime import datetime

def send(subj=None, to_addr=None, from_addr=None):
    text = sys.stdin.read()
    # attempt to parse sensu message
    try:
        data = json.loads(text)
        host = data.get('client', {}).get('name')
        check_name = data.get('check', {}).get('name')
        check_action = data.get('action')
        timestamp = data.get('check', {}).get('issued')
        check_date = datetime.fromtimestamp(int(timestamp)).strftime('%Y-%m-%d %H:%M:%S')
        parts = (
            'Date: {0}'.format(check_date),
            'Host: {0}'.format(host),
            'Address: {0}'.format(data.get('client', {}).get('address')),
            'Action: {0}'.format(check_action),
            'Name: {0}'.format(check_name),
            'Command: {0}'.format(data.get('check', {}).get('command')),
            'Ouput: {0}'.format(data.get('check', {}).get('output')),
        )
        text = '\n'.join(parts)
        subj = '{0} [{1}: {2} ({3})]'.format(subj, host, check_name, check_action)
    except Exception, e:
        text = str(e)
    msg = MIMEText(text)
    msg['Subject'] = subj
    msg['To'] = to_addr
    msg['From'] = from_addr
    s = smtplib.SMTP('localhost')
    s.sendmail(from_addr, [to_addr], msg.as_string())
    s.quit()

if __name__=='__main__':
    op = OptionParser()
    op.add_option('-s', action='store', dest='subject')
    op.add_option('-t', action='store', dest='to_addr')
    op.add_option('-f', action='store', dest='from_addr')
    opts, args = op.parse_args()
    send(opts.subject, opts.to_addr, opts.from_addr)
    sys.exit(0)

