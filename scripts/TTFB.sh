#! /bin/bash/
echo ""
read -p "Bitte URL eingeben: " 
curl -o /dev/null "$1" -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n"
