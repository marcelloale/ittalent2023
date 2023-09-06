#!/bin/bash

# ref: https://ostechnix.com/how-to-find-and-delete-files-older-than-x-days-in-linux/
find /var/log -name "*.log" -mtime +7 -exec rm -f {} \;
