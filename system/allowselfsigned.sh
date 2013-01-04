#!/bin/bash

###############################
## Zimbra System Tools       ##
## Allow self signed SSL     ##
## (c) 2013 by               ##
## virtualmarc @ GitHub      ##
###############################

CURUSER=`whoami`

if [ "$CURUSER" = "zimbra" ];
then
	echo -n "Allowing self signed Certificates... "
	zmlocalconfig -e 'data_source_trust_self_signed_certs=true'
	zmlocalconfig -e 'ssl_allow_accept_untrusted_certs=true'
	echo "[DONE]"
	echo "Please restart Zimbra"
else
if [ "$CURUSER" = "root" ];
then
	echo -n "Allowing self signed Certificates... "
	su -c "zmlocalconfig -e 'data_source_trust_self_signed_certs=true'" zimbra
	su -c "zmlocalconfig -e 'ssl_allow_accept_untrusted_certs=true'" zimbra
	echo "[DONE]"
	echo "Please restart Zimbra"
else
	echo "This script must be run as root or zimbra. Use: sudo ./fixperms.sh"
fi
fi
