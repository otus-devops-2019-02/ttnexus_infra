#!/usr/bin/env python
import os
import json
from python_terraform import *

wdir = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '../terraform/stage'))

if not os.path.isdir(wdir):
    raise Exception('Directory `%s` not found' % (wdir))

tform = Terraform(working_dir=wdir)
vars = tform.output()

out = {
    'app': {
        'hosts': ["apphost"],'vars':{}
    },
    'db': {
        'hosts': ["dbhost"],'vars':{}
    },
    '_meta': {
        'hostvars': {
            'dbhost':{
                'ansible_host': vars['db_external_ip']['value']
            },
            'apphost':{
                'ansible_host': vars['app_external_ip']['value'][0]
            }
        }
    }
}

print(json.dumps(out))

