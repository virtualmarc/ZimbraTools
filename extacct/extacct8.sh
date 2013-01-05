#!/bin/sh
##############################
## ZimbraTools              ##
## Send from external       ##
## accounts ZCS 8.X         ##
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
		zmlocalconfig -e postfix_smtp_sender_dependent_authentication=yes
		zmlocalconfig -e postfix_sender_dependent_relayhost_maps=hash:/opt/zimbra/conf/relayhost_map
		zmlocalconfig -e postfix_smtp_sasl_auth_enable=yes
		zmlocalconfig -e postfix_smtp_sasl_password_maps=hash:/opt/zimbra/conf/relay_password
		zmlocalconfig -e postfix_smtp_cname_overrides_servername=no
		zmlocalconfig -e postfix_smtp_use_tls=no
		zmlocalconfig -e postfix_smtp_sasl_security_options=noanonymous
		postmap /opt/zimbra/conf/relayhost_map
		postmap /opt/zimbra/conf/relay_password
		echo "[DONE]"
		echo "Please Restart Zimbra to enable the configuration!"
	else
		echo "Please run this script as user root or user zimbra!"
	fi
fi
