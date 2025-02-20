#!/bin/bash

LOGFILE="/var/log/mautic-cron.log"
CONTAINER_NAME="mautic"

docker exec $CONTAINER_NAME php /var/www/html/bin/console mautic:segments:update >> $LOGFILE 2>&1
docker exec $CONTAINER_NAME php /var/www/html/bin/console mautic:campaigns:update >> $LOGFILE 2>&1
docker exec $CONTAINER_NAME php /var/www/html/bin/console mautic:campaigns:trigger >> $LOGFILE 2>&1
docker exec $CONTAINER_NAME php /var/www/html/bin/console messenger:consume email >> $LOGFILE 2>&1
docker exec $CONTAINER_NAME php /var/www/html/bin/console mautic:queue:process >> $LOGFILE 2>&1
docker exec $CONTAINER_NAME php /var/www/html/bin/console mautic:email:fetch >> $LOGFILE 2>&1

