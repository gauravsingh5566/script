#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import sys

# Define the command to check the Nginx service status
#cmd = 'service nginx status'
error_log_path = '/var/log/nginx/error.log'
# Run the command and get the output
#try:
output = subprocess.check_output(['sudo','service', 'nginx', 'status']).decode('utf-8')
log_output = subprocess.check_output(['tail', '-n', '10', error_log_path]).decode('utf-8') 
#except subprocess.CalledProcessError as e:
#    print(log_output)
#    print(f"Error running command: {e}")
#    sys.exit(1)

# Check if the output indicates that the service is running
if "Active: active" in str(output):
    print("Nginx service is running")
    sys.exit(0)
else:
    log_output = subprocess.check_output(['tail', '-n', '10', error_log_path]).decode('utf-8') 
    print("Nginx service is not running")
    print(log_output)
    sys.exit(1)


