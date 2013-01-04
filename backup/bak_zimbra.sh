#!/bin/bash
# Backup Script
# Zimbra Accounts backuppen
# Run as user Zimbra
# (c) 2012 by virtualmarc @ GitHub

echo "[BAK2] Running bak_zimbra.sh"

FOLDER="/backup"

for mbox in `zmprov -l gaa`
do
	MBSTART="$(date +%s)"
	echo "[BAK2] Creating file backups for $mbox"
	/opt/zimbra/bin/zmmailbox -z -m $mbox getRestURL "//?fmt=zip" > $FOLDER/backups/acct/$1/files/$mbox.files.zip
	echo "[BAK2] Creating filter backups for $mbox"
	/opt/zimbra/bin/zmprov ga $mbox zimbraMailSieveScript > $FOLDER/backups/acct/$1/files/$mbox.filter
	MBENDE="$(date +%s)"
	elapsed="$(expr $MBENDE - $MBSTART)"
	hours=$(($elapsed / 3600))
	elapsed=$(($elapsed - $hours * 3600))
	minutes=$(($elapsed / 60))
	seconds=$(($elapsed - $minutes * 60))
	echo "[BAK2] $mbox took $hours hours $minutes minutes $seconds seconds"
done

echo "[BAK2] bak_zimbra.sh finished"
