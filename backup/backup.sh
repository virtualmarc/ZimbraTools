#!/bin/bash
# Backup Script
# backup Zimbra Files
# (c) 2012 by virtualmarc @ GitHub

FOLDER="/backup"
LOGFILE="$FOLDER/bak.log"
EMAIL="your@mail.com"
START="$(date +%s)"

echo "Logfile: ${LOGFILE}" &> ${LOGFILE}

#
# RUN FIRST BACKUP
# FULL BACKUP
#

echo "===========================" &>> ${LOGFILE}
echo "=Running [BAK1] full image=" &>> ${LOGFILE}
echo "===========================" &>> ${LOGFILE}

date=`date '+%u'`
echo "[BAK1] Starting backup on `date` (No ${date})" &>> ${LOGFILE}

rm -Rf $FOLDER/backups/full/${date}/ &>> ${LOGFILE}
echo "[BAK1] Removed local backup no ${date}" &>> ${LOGFILE}

mkdir $FOLDER/backups/full/${date} &>> ${LOGFILE}

DOWNSTART="$(date +%s)"
echo "[BAK1] Stopping Zimbra for backup" &>> ${LOGFILE}
/etc/init.d/zimbra stop &>> ${LOGFILE}
ps auxww | awk '{print $1" "$2}' | grep zimbra | kill -9 `awk '{print $2}'` &>> ${LOGFILE}

BEFORE="$(date +%s)"
echo "[BAK1] Creating backup" &>> ${LOGFILE}
tar cf $FOLDER/backups/full/${date}/backup-files-${date}.tar /opt/zimbra &>> ${LOGFILE}
echo '[BAK1] Created backup' &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK1] Backup took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

echo "[BAK1] Starting Zimbra" &>> ${LOGFILE}
/etc/init.d/zimbra start &>> ${LOGFILE}
DOWNEND="$(date +%s)"
elapsed="$(expr $DOWNEND - $DOWNSTART)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK1] Zimbra was down for $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

BEFORE="$(date +%s)"
echo "[BAK1] Compressing backup" &>> ${LOGFILE}
gzip -9 --best $FOLDER/backups/full/${date}/backup-files-${date}.tar &>> ${LOGFILE}
echo '[BAK1] Compressed backup' &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK1] Compressing took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

BEFORE="$(date +%s)"
echo "[BAK1] Uploading backup" &>> ${LOGFILE}
ncftpput -m -f $FOLDER/ftp.cfg /zimbra/ $FOLDER/backups/full/${date}/backup-files-${date}.tar.gz &>> ${LOGFILE}
echo '[BAK1] Uploaded backup to ftp' &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK1] Upload took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

echo "[BAK1] Backup ended on `date`" &>> ${LOGFILE}
END1="$(date +%s)"

elapsed="$(expr $END1 - $START)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK1] Full Backup took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

#
# SECOND BACKUP
# SINGLE ACCOUNTS
#

START1="$(date +%s)"
echo "==============================" &>> ${LOGFILE}
echo "=Running [BAK2] single images=" &>> ${LOGFILE}
echo "==============================" &>> ${LOGFILE}

date=`date '+%u'`
echo "[BAK2] Starting backup on `date` (No ${date})" &>> ${LOGFILE}

rm -Rf $FOLDER/backups/acct/${date}/ &>> ${LOGFILE}
echo "[BAK2] Removed local backup no ${date}" &>> ${LOGFILE}

mkdir $FOLDER/backups/acct/${date} &>> ${LOGFILE}
mkdir $FOLDER/backups/acct/${date}/files &>> ${LOGFILE}
chmod 777 $FOLDER/backups/acct/${date} -R &>> ${LOGFILE}

BEFORE="$(date +%s)"
su - zimbra -c "$FOLDER/bak_zimbra.sh ${date}" &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK2] Backup took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

BEFORE="$(date +%s)"
echo "[BAK2] Archiving backups" &>> ${LOGFILE}
tar cf $FOLDER/backups/acct/${date}/backup-acct-${date}.tar $FOLDER/backups/acct/${date}/files/ &>> ${LOGFILE}
echo "[BAK2] Archive created" &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK2] Archiving took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

BEFORE="$(date +%s)"
echo "[BAK2] Compressing archive" &>> ${LOGFILE}
gzip -9 --best  $FOLDER/backups/acct/${date}/backup-acct-${date}.tar &>> ${LOGFILE}
echo "[BAK2] Compressed archive" &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK2] Compressing took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

BEFORE="$(date +%s)"
echo "[BAK2] Uploading backup" &>> ${LOGFILE}
ncftpput -m -f $FOLDER/ftp2.cfg /zimbra/ $FOLDER/backups/acct/${date}/backup-acct-${date}.tar.gz &>> ${LOGFILE}
echo "[BAK2] Upload complete" &>> ${LOGFILE}
AFTER="$(date +%s)"
elapsed="$(expr $AFTER - $BEFORE)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK2] Uploading took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

echo "[BAK2] Backup ended on `date`" &>> ${LOGFILE}

ENDE="$(date +%s)"
elapsed="$(expr $ENDE - $START1)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "[BAK2] Account Backup took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

###########

elapsed="$(expr $ENDE - $START)"
hours=$(($elapsed / 3600))
elapsed=$(($elapsed - $hours * 3600))
minutes=$(($elapsed / 60))
seconds=$(($elapsed - $minutes * 60))
echo "Script took $hours hours $minutes minutes $seconds seconds" &>> ${LOGFILE}

echo "Sending Logfile to admin@vmtek.de"

mutt -s "Backup Log Nr. ${date} from `date`" $EMAIL < ${LOGFILE}
