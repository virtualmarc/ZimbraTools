#!/bin/sh
##############################
## ZimbraTools              ##
## Send from external       ##
## accounts ZCS 7.X         ##
## (c) 2013 by              ##
## virtualmarc @ GitHub     ##
##############################

CURUSER=`whoami`

echo $0

if [ "$CURUSER" = "root" ];
then
	DIR=`dirname $0`
	su -c "$DIR/$0" zimbra
else
	if [ "$CURUSER" = "zimbra" ];
	then
		# Run the commands
		echo -n "Enabling external account relaying... "
		zmprov mc default zimbraSmtpRestrictEnvelopeFrom FALSE
		postconf -e smtp_sender_dependent_authentication=yes
		postconf -e sender_dependent_relayhost_maps=hash:/opt/zimbra/conf/relayhost_map
		postconf -e smtp_sasl_auth_enable=yes
		postconf -e smtp_sasl_password_maps=hash:/opt/zimbra/conf/relay_password
		postconf -e smtp_cname_overrides_servername=no
		postconf -e smtp_use_tls=no
		postconf -e smtp_sasl_security_options=noanonymous
		postmap /opt/zimbra/conf/relayhost_map
		postmap /opt/zimbra/conf/relay_password
		postfix reload
		echo "[DONE]"
	else
		echo "Please run this script as user root or user zimbra!"
	fi
fi
