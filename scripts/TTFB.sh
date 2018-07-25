#! /bin/bash/

read -p 'Bitte die Website eingeben:_' $1 

curl -o /dev/null -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n"  
echo "$1"
