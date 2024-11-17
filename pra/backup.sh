#!/bin/bash

# set the source and destination dir

source="/etc/"
destination="/home/amaan/bak/"
date="$(date +%Y-%m-%d)"
backup_file="$destination/backup_$date.tar.gz"

# create backup using tar

tar -czf $backup_file $source


# Optional: Encrypt the backup
# gpg --symmetric --cipher-algo AES256 $backup_file


# remove backups older than 7

find $destination -type -f -name "*.tar.gz" -mtime +7 -exec rm {} \;

echo "backup completed successfully!"

