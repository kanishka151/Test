#!/bin/bash

monitored_dir="/path/to/directory"
log_file="file_monitor.log"
db_name="file_db"

echo "Monitoring directory: $monitored_dir"

while inotifywait -r -e modify,create "$monitored_dir"; do
    largest_file=$(find "$monitored_dir" -type f -exec du -b {} + | sort -nr | head -n 1 | awk '{print $2}')
    file_size=$(stat -c%s "$largest_file")
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$timestamp - File Processed: $largest_file, Size: $file_size bytes" >> "$log_file"

    # Upload to SQL Database
    sqlite3 "$db_name.db" "INSERT OR IGNORE INTO files (name, size, timestamp) VALUES ('$largest_file', $file_size, '$timestamp');"
done
