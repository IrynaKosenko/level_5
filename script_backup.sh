#!/bin/bash

# What to backup.
src="/tmp"

# Where to backup to.
dest="mybackups"

# Create archive filename.
day=$(date +%F_%H%M%S)
archive_file="$src-$day.tar.gz"

echo >> "$dest/cron_log.txt"
echo "The script starts" >> "$dest/cron_log.txt"
echo $day >> "$dest/cron_log.txt"

# Create the backup folder if don`t exists
if [ ! -d "$dest" ]; then
    mkdir -p "$dest"
    echo "Created dir: '$dest'" >> "$dest/cron_log.txt"
fi

# Find files older then 3 minutes and backup the files using tar.gz
find $src -type f -mmin +3 -print0 | xargs -0 tar czf $dest/$archive_file

if [ $? -eq 0 ]; then
    echo "Backup successfull: $archive_file"  >> "$dest/cron_log.txt"
else
    echo "Backup failed or there are no one files or files older than three minutes"  >> "$dest/cron_log.txt"
fi

# Removes files older than 3 minutes
find $src -type f -mmin +3 -exec rm {} \;
echo "Backup finished"  >> "$dest/cron_log.txt"
