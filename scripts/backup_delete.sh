#! /bin/bash

# Delete backups which are older then 7 days on NFS

BACKUPS_DIR="/nfs-export/www/save/backup_mysql/"
find $BACKUPS_DIR -type f -mtime +6 -name '*.gz' -exec rm {} \;


