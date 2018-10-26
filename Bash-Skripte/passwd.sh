#!/bin/bash
#IF Anweisung in der Praxis

if grep "$1" /etc/passwd > /dev/null 2>$1
then
echo "Ja den Benutzer $1 gibt es"
exit 0;
fi
echo "Nein den Benutzer $1 gibt es nicht"
