#!/bin/bash

log_file="killed_processes.log"

while true; do
    processes=$(ps aux | grep "Kill_Me" | grep -v grep | awk '{print $2, $11}')

    if [[ ! -z "$processes" ]]; then
        echo "$processes" | while read pid process_name; do
            echo "$(date): Killing process $process_name with PID $pid" >> "$log_file"
            kill -9 $pid
        done
    fi
    
    sleep 5
done
