#!/bin/bash
###############################
## ZimbraTools               ##
## Send from external        ##
## accounts Add ext Accounts ##
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
                read -p "E-Mail address: " EMAIL_ADDR
                read -p "SMTP-Username:  " EMAIL_USER
                read -p "SMTP-Password:  " -s EMAIL_PASS
                echo ""
                read -p "SMTP-Server:   " EMAIL_SERVER
                read -p "SMTP-Port:      " -e -i 25 EMAIL_PORT
                echo "$EMAIL_ADDR $EMAIL_SERVER:$EMAIL_PORT" >> /opt/zimbra/conf/relayhost_map
                echo "$EMAIL_ADDR $EMAIL_USER:$EMAIL_PASS" >> /opt/zimbra/conf/relay_password
                echo "Successfully added"
                read -p "Add another address? [Y/N]: " -e -i N ADD_ANOTHER
                if [ "$ADD_ANOTHER" == "Y" ]
                then
                  ./$0 skipgen
                fi
                if [ "$1" == "skipgen" ]
                then
                  exit 1
                else
                  ./refeshacct.sh
                fi
        else
                echo "Please run this script as user root or user zimbra!"
        fi
fi
