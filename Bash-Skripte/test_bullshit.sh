
#!/bin/bash
#IF-ELSE-Anweisungen

if grep "$1" /etc/passwd > /dev/null 2>$1
then
echo "Ja den Benutzer $1 gibt es"

#Weitere Kommandos eingeben
else
echo "Nein den Benutzer $1 gibt es nicht"

#Weitere Kommandos eingeben
fi
