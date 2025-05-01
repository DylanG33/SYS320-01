#!/bin/bash

# Fetch IOCs from the web page and save to IOC.txt
curl -s http://10.0.17.6/IOC.html | \
 grep -oP '<td>.*?</td>' | sed -E 's/<td>(.*)<\/td>/\1/' | awk 'NR%2==1' > IOC.txt
