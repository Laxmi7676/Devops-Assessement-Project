#!/bin/bash

URL="http://localhost/health"

LOGFILE="/var/log/health.log"

TIMESTAMP=$(date)

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$STATUS" == "200" ]
then
    echo "$TIMESTAMP - UP" >> $LOGFILE
else
    echo "$TIMESTAMP - DOWN" >> $LOGFILE
fi
