#!/bin/bash

###############################
## Zimbra System Tools       ##
## Fix Permissions           ##
## (c) 2013 by               ##
## virtualmarc @ GitHub      ##
###############################

CURUSER=`whoami`

if [ "$CURUSER" = "root" ];
then
	echo -n "Fixing permissions... "
	/opt/zimbra/libexec/zmfixperms --extended
	echo "[Done]"
else
	echo "This script must be run as root. Use: sudo ./fixperms.sh"
fi
