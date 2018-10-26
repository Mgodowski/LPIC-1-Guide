root@cron72:~# tail -n 1000 /var/www10/log_plenty_global/db/dbConnector.log Mon, 19 Mar 2018 01:01:05 +0000 30.30.20.63 host: db20.plenty-shop.de db: PLENTY_ID not defined error: (2003) Can't connect to MySQL server on 'db20.plenty-shop.de' (110) Mon, 19 Mar 2018 05:43:46 +0100 30.30.4.210 host: db06.aws-ffm-02.de db: p9185 PLENTY_ID not defined error: (1040) Too many connections root@cron72:~# date +"%a, %d %b %Y %H" Mon, 19 Mar 2018 22 

tail -n 1000 /var/www10/log_plenty_global/db/dbConnector.log

 user_max_connections=$(tail -n 1000 /var/www10/log_plenty_global/db/dbConnector.log | grep "$(date +"%a, %d %b %Y %H")" | grep "Too many connections" | awk '{print $11}' > /tmp/dbtest/)


 tail -n 1000 /var/www10/log_plenty_global/db/dbConnector.log
und dann
date +"%a, %d %b %Y %H"

root@cron72:~# tail -n 1000 /var/www10/log_plenty_global/db/dbConnector.log

user_max_connections=$(tail -n 1000 /var/www10/log_plenty_global/db/dbConnector.log | grep "Mon, 19 Mar 2018 05" | grep "Too many connections" | awk '{print $11}' > /tmp/dbtest/)