#!/bin/zsh
# Backup Script
# backup Zimbra Files
# Dont forget to install zsh and set the ZCSACCOUNT
# (c) 2014 by virtualmarc @ GitHub

ZCSACCOUNT="user@domain.tld"

echo "Deleting all Calendar entries"
zmmailbox -z -m $ZCSACCOUNT ef /Calendar

function newName()
{
        content=${@// /}
        echo -n ${content//[^a-zA-Z0-9\.\-_]/}
}

echo "Replacing special characters"
IFS=$'\n'
for file in `ls *.ics`
do
        NEW_NAME=`newName $file`
        if [ "$file" != $NEW_NAME ]
        then
                mv "$file" `newName $file`
        fi
done

NUM=1

echo "Importing Calendar entries"
for file in `ls *.ics`
do
        echo "Importing $file"
        zmmailbox -z -m $ZCSACCOUNT pru /Calendar "$file"
        echo "Exitstatus: $?"
        NUM=$(($NUM+1))
done

echo "Imported: $NUM"
