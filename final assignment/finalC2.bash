#!/bin/bash

logfile="$1"
iocfile="$2"

# Read IOCs into array
mapfile -t iocs < "$iocfile"

# Process log entries
while IFS= read -r line; do
    ip=$(awk '{print $1}' <<< "$line")
    datetime=$(grep -oP '\[\K[^]]+' <<< "$line" | cut -d' ' -f1)
    url=$(awk -F'"' '{print $2}' <<< "$line" | awk '{print $2}')

    for ioc in "${iocs[@]}"; do
        if [[ "$url" == *"$ioc"* ]]; then
            echo "$ip $datetime $url"
            break
        fi
    done
done < "$logfile" > report.txt
