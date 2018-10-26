#!/bin/bash
MOUNTFILE=/Volumes/mgodowski/.mounted
LOCKFILE=/tmp/lock_backup_files.lock

if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "Backup is already running"
    exit
fi

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

if [ -f $MOUNTFILE ];
then
   echo "NAS is mounted -> I start"
   rsync -auv --delete /Users/martingodowski/Desktop/Archiv*    /Volumes/mgodowski/Backups/Mac/mgodowski/
   rsync -auv --delete /Users/martingodowski/Documents 			/Volumes/mgodowski/Backups/Mac/mgodowski/   
   rsync -auv --delete /Users/martingodowski/Library   			/Volumes/mgodowski/Backups/Mac/mgodowski/
   rsync -auv --delete /Users/martingodowski/Downloads 			/Volumes/mgodowski/Backups/Mac/Downloads/
else
   echo "NAS is not mounted -> Cant start"
fi


