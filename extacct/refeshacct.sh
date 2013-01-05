#!/bin/sh
###############################
## ZimbraTools               ##
## Send from external        ##
## accounts Refresh Accounts ##
## (c) 2013 by               ##
## virtualmarc @ GitHub      ##
###############################

CURUSER=`whoami`

echo $0

if [ "$CURUSER" = "root" ];
then
        DIR=`dirname $0`
        su -c "$DIR/$0" zimbra
else
        if [ "$CURUSER" = "zimbra" ];
        then
		echo -n "Refreshing Account Databases... "
		postmap /opt/zimbra/conf/relayhost_map
                postmap /opt/zimbra/conf/relay_password
                postfix reload
		echo "[DONE]"
	else
                echo "Please run this script as user root or user zimbra!"
        fi
fi
