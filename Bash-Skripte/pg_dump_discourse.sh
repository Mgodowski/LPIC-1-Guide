#!/bin/bash

# Author: Mathgo
# Backup the discourse Postgresql database into a daily file on S3 at the end.

#cPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

DB_HOST="discourse.cdy30ammt2c0.eu-central-1.rds.amazonaws.com"
DB_PORT="5432"
DB_NAME="discourse"
DB_USER="discourse"
DB_PASS="wPmPkUjiXm9cJDiIKUtK"
DB_OPTS="--no-password --compress=9"
#S3_KEY=""
#S3_SKEY=""
BACKUP_DIR="/tmp/discourse_bkp"
DATE=`date +"%Y-%m-%d_%T"`
FILE=${DATE}_discouse.sql.gz
OUTPUT_FILE=${BACKUP_DIR}/${FILE}

# Create required directories
#if [ ! -e "$BACKUP_DIR" ]		# Check Backup Directory exists.
#	then
#	mkdir -p "$BACKUP_DIR"
#fi

# .pgpass-convention --> hostname:port:database:username:password
echo $DB_HOST:$DB_PORT:$DB_NAME:$DB_USER:$DB_PASS > ~/.pgpass
chmod 600 ~/.pgpass

# dump the database
echo "dump and gzip database on the fly"
/usr/bin/pg_dump --host=$DB_HOST --port=$PORT --username=$DB_USER $DB_OPTS --dbname=$DB_NAME -F p -f $OUTPUT_FILE 

# Upload to S3
echo "upload to s3"
/usr/bin/aws s3 cp $OUTPUT_FILE s3://plentymarkets-forum-discourse-backup 

# remove all files in our source directory
echo "local clean-up.."
rm /tmp/$BACKUP_DIR/*    

