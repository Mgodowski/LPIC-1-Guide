 #! /bin/bash
  2
  3 RED='\033[0;31m'
  4 NC='\033[0m'
  5
  6 #### GET NGinx Server STATS
  7
  8 SLEEP=5
  9 MY_NAME=$(hostname)
 10 MY_CSV_BASIC_FILE="/var/www3/plenty_cache/load_balancer/health/lbHealthStatus_"$MY_NAME"*.csv"
 11 MY_TEMP_FILE="/tmp/plenty_LB_COnnections_counter"
 12 MY_TEMP_LOCK="/tmp/plenty_LB_COnnections_counter.lock"
 13
 14 DURCHLAUF=3
 15 ### Refresh Connections after
 16 MAX_DURCHLAUF=10
 17
 18 ####### How Many Percent of SYNC Connection to TOTAL CONENECTIONS
 19 ####### per NginX are allowed before ALARM
 20 DDOS_PERCENT=15
 21
 22
 23 case $1 in
 24         status)
 25                 rm -f $MY_TEMP_FILE
 26                 while true;
 27                  do
 28 #                       #OUTPUT="plentyLBStatus for Host - $MY_NAME - LoadAVG: $(cat /proc/loadavg | cut -d " " -f 1-3)\n$(date)\t : Refresh Connections in $(($MAX_DURCHLAUF-$DURCHLAUF))\n============================================    ========================\n"
 29                         OUTPUT="$MY_NAME  -  LoadAVG: $(cat /proc/loadavg | cut -d " " -f 1)  -  $(date +%H\:%M\:%S)\n"
 30                         OUTPUT="$OUTPUT NGINX  \tCONN\tLAVG\tWGHT\n======================================\n"
 31                         for ZEILE in $(cat $MY_CSV_BASIC_FILE | grep -v "host,ip");
 32                          do
 33                                 NGINX_SERVER=$(echo $ZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $1}')
 34                                 #NGINX_IP=$(echo $ZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $3}')
 35                                 NGINX_LOAD=$(echo $ZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $4}')
 36                                 NGINX_WEIGTH=$(echo $ZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $5}')
 37
 38                                 NGINX_CONNECTIONS=$(grep  $NGINX_SERVER   $MY_TEMP_FILE 2>/dev/null |awk '{print $2}')
 39                                 if [ -z "$NGINX_CONNECTIONS" ];
 40                                  then
 41                                         NGINX_CONNECTIONS="N/A"
 42                                 fi
 43
 44                                 if [ "$NGINX_LOAD" == "1000" ] ; then
 45                                         NGINX_LOAD="${RED}${NGINX_LOAD}${NC}"
 46                                 fi
 47
 48                                 OUTPUT="$OUTPUT\n$NGINX_SERVER  \t$NGINX_CONNECTIONS\t$NGINX_LOAD\t$NGINX_WEIGTH\n"
 49
 50                                 WEB_CSV_BASIC_FILE="/var/www3/plenty_cache/load_balancer/health/lbHealthStatus_"$NGINX_SERVER"*.csv"
 51
 52                         #       for UNTERZEILE in $(cat $WEB_CSV_BASIC_FILE | grep -v "host,ip");
 53                         #        do
 54                 #                       WEB_SERVER=$(echo $UNTERZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $1}')
 55                         #               WEB_IP=$(echo $UNTERZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $3}')
 56                         #               if [ $(echo $WEB_IP | grep "\." > /dev/null 2>&1 ; echo $?;) -eq 0 ];
 57                         #                then
                        #                       WEB_LOAD=$(echo $UNTERZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $4}')
 59                         #                   WEB_WEIGTH=$(echo $UNTERZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $5}')
 60                         #                else
 61                         #                       ### KEINE IP vorhanden
 62                         #                       WEB_LOAD=$(echo $UNTERZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $3}')
 63                         #                       WEB_WEIGTH=$(echo $UNTERZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $4}')
 64                         #               fi
 65
 66                         #               # Connections For WebServer not checkable on a LB-Server
 67                         #               #WEB_CONNECTIONS=$(grep  -c "$(printf '%02X' ${WEB_IP//./ })"   /proc/net/ip_vs_conn)
 68                         #               WEB_CONNECTIONS="N/A"
 69                         #
 70                         #               if [ -z "$WEB_SERVER" ];
 71                          #               then
 72                         #                       OUTPUT="$OUTPUT\t->\tERROR - \t BACKEND Failure \n"
 73                         #                else
 74                         #                       OUTPUT="$OUTPUT\t->\t$WEB_SERVER\t-\t$WEB_CONNECTIONS\t-\t$WEB_LOAD\t-\t$WEB_WEIGTH\n"
 75                         #               fi
 76                         #        done
 77
 78                                 ((++DURCHLAUF))
 79
 80                                 ####### Trigger New Connection Reader
 81                                 if [ $DURCHLAUF -eq $MAX_DURCHLAUF ];
 82                                  then
 83                                         $0 get_connections &
 84                                         DURCHLAUF=1
 85                                 fi
 86                          done
 87
 88                         clear;
 89                         echo -e "$OUTPUT"
 90                         sleep $SLEEP
 91                         #echo "REFRESHING ..."
 92                         echo "..."
 93                  done;;
 94
 95         get_connections)
 96                         if [ ! -f "$MY_TEMP_LOCK" ];
 97                          then
 98                                 touch $MY_TEMP_LOCK
 99                                 CONN_TABLE=$(netstat -tulpenat | grep "^tcp\s" | sed s/\:/\ /g| awk '{print $6}')
100                                 TEMP_OUTPUT=""
101                                  for ZEILE in $(cat $MY_CSV_BASIC_FILE | grep -v "host,ip");
102                                    do
103                                         NGINX_SERVER=$(echo $ZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $1}')
104                                         NGINX_IP=$(echo $ZEILE | sed s/\,/\ /g | sed s/\\./\ / | awk '{print $3}')
105
106                                         NGINX_CONNECTIONS=$(echo "$CONN_TABLE" | grep  -c "$NGINX_IP$")
107                                         NGINX_DDOS=$(echo "$CONN_TABLE" | grep SYN | grep  -c "$(printf ${NGINX_IP})" )
108                                         if [ $NGINX_DDOS -gt $(($(($NGINX_CONNECTIONS/100))*$DDOS_PERCENT)) ];
109                                           then
110                                                 NGINX_CONNECTIONS="(D)DOS-ALARM"
											  else
112                                                 NGINX_CONNECTIONS="$NGINX_CONNECTIONS"
113                                         fi
114                                         TEMP_OUTPUT="$TEMP_OUTPUT\n$NGINX_SERVER\t$NGINX_CONNECTIONS"
115                                   done
116                                 echo -e "$TEMP_OUTPUT" > $MY_TEMP_FILE
117                                 rm -f $MY_TEMP_LOCK
118
119
120                                 exit 0
121
122                          else
123                                 if [ $(($(date +%s)-$(stat -c %Y $MY_TEMP_LOCK))) -gt 600 ];
124                                   then
125                                         rm -f $MY_TEMP_LOCK
126                                 fi
127                         fi;;
128
129         *)
130                 echo ""
131                 echo "Usage: "
132                 echo ""
133                 echo "$0 { start | status | stop}"
134                 echo ""
135                 exit 0;;
136 esac