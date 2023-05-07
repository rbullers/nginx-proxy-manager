#!/bin/bash env
# Autowhitelist multiple DDNS Addresses for nginx
# Author: Mike from https://guides.wp-bullet.com/

#define Dynamic DNS addresses here
DDNS[0]=""
DDNS[1]=""

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
				echo "${DDNS[$i]} - IP Address Updated"
	    done
	nginx -s reload
else
	for i in $(eval echo "{0..$DNSCOUNT}")
	    do
				echo "${DDNS[$i]} IP Address Hasn't Changed"
		done
fi
