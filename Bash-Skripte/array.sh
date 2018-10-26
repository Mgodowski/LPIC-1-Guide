#!/bin/bash
#Kursübung
#Arrays belegen, auslesen, löschen

flugzeug=(Airbus Boeing Concorde)

flugzeug+=(Bombardier Fokker Saab)

# unset flugzeug

echo ${flugzeug[@]}

