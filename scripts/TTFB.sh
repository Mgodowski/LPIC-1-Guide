#! /bin/bash/

read -p "Bitte URL eingeben:" 
curl -o /dev/null \
     -H 'Cache-Control: no-cache' \
     -s \
     -w "Connect: %{time_connect} \\n
	    TTFB: %{time_starttransfer} \\n
	    Total time: %{time_total} \\n" \\
echo $1
