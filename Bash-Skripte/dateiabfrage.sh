#!/bin/bash
#Zustand abfragen von Verzeichnissen und Dateien

if [ -d Lol ]
then
	echo "Das Verzeichnis existiert"
	if [ -f Lol/abc.txt ]
	then
	echo "Die Datei existiert"
	read -p "Soll die Datei gelöscht werden (J / N): " erstellen
		if [ $erstellen = J ]
		then
		rm Lol/abc.txt
		echo "Die Datei wurde gelöscht"
		fi
	else
	echo "Die Datei existiert NICHT"
	read -p "Soll diese Datei erstellt werden (J / N): " erstellen
		if [ $erstellen = J ]
		then
		touch Lol/abc.txt
		echo "Die Datei wurde erstellt"
		else
		echo "Die Datei wurde nicht erstellt"
		fi
	fi

else
	echo "Existiert nicht"
fi
