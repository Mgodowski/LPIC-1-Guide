#! /bin/bash

BACKUPS_DIR="find /var/save/backup/ -name '*.gz' "
# gelöschte Backups_name speichern
# aktueller Timestamp , dann älter als 7 Tage
# diese Prüfen und dann löschen

cd $BACKUPS_DIR


