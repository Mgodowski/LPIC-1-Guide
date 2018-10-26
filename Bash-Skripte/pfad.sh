#!/bin/bash
#Variablen Schnitt-Funktion

pfad="/var/www/thinksecre/index.html"

echo $pfad
# Die ganze Zeile anzeigen


# Entfernt das kleinste passende Stück von rechts
# keine Datei angezeigt
echo "${pfad%/*}"

# Entfernt das größte passende Stück von rechts
# Keine Ausgabe produziert
echo "${pfad%%/*}"

# Entfernt das kleinste passende Stück von links
# ohne anführendes /
echo "${pfad#*/}"

# Entfernt das größte passende Stück von links 
# index.html
echo "${pfad##*/}"

