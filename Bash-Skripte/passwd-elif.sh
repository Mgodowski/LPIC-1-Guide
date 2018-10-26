#!/bin/bash
#If - Elif - Else Anweisung

# martin MARTIN 
if grep "$1" /etc/passwd > /dev/null 2>$1
then
echo "Ja den Benutzer $1 gibt es"
#Weitere Kommandos eingeben
elif grep "${1,,}" /etc/passwd > /dev/null 2>$1
then 
echo "Ja der Benutzer ${1,,} wurde nur mit Kleinbuchstaben gefunden"
elif grep "${1^^}" /etc/passwd > /dev/null 2>$1
then 
echo "Ja der Benutzer ${1^^} wurde nur mit Großbuchstaben gefunden"
else
echo "Nein den Benutzer $1 gibt es nicht"
#Weitere Kommandos eingeben
fi
