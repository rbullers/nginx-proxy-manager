#!/bin/bash
# Autowhitelist multiple DDNS Addresses for nginx
# Author: Mike from https://guides.wp-bullet.com/

echo "DDNS_HOST=$DDNS_HOST" > /etc/environment
#define Dynamic DNS addresses here
DDNS=($DDNS_HOST)

#create an array of the dynamic IPs
if [ ! -f /etc/nginx/conf.d/dynamicips ]; then
        for DNS in "${DDNS[@]}"
        do
            echo "allow $(dig x +short $DNS);" >> /etc/nginx/conf.d/dynamicips
        done
fi

#create current array for comparison with fresh IPs
CURRENT=($(cat /etc/nginx/conf.d/dynamicips))
#Generate fresh list
let "DNSCOUNT=${#DDNS[@]} - 1"
for i in $(eval echo "{0..$DNSCOUNT}")
        do
            FRESH[$i]="allow $(dig x +short ${DDNS[$i]});"
        done

#compare old list and new list, create new file if there are differences
CURRENTAGG=${CURRENT[@]};
FRESHAGG=${FRESH[@]};
if [ "$CURRENTAGG" != "$FRESHAGG" ]; then
        rm /etc/nginx/conf.d/dynamicips
        for i in $(eval echo "{0..$DNSCOUNT}")
            do
                        echo "${FRESH[$i]}" >> /etc/nginx/conf.d/dynamicips
            done
		
        echo "$(date '+%Y-%m-%d %T'): IP Addresses Updated"
        /usr/sbin/nginx -s reload
else
        echo "$(date '+%Y-%m-%d %T'): No Changes"
fi