#!/bin/zsh
# Import Script
# Import .eml E-Mail files
# Dont forget to install zsh and set the ZCSACCOUNT
# (c) 2013 by virtualmarc @ GitHub
# Thanks to: lukas2511 @ GitHub

ZCSACCOUNT="user@domain.tld"

function newName()
{
        content=${@// /}
        echo -n ${content//[^a-zA-Z0-9\.\-_]/}
}

echo "Beginning Import"
IFS=$'\n'
for folder in $(find . -type d)
do
        if [ "$folder" != "." ]
        then
                NEWFOLDER=`newName $folder`
                echo "Current Folder: $folder"
                if [ "$folder" != $NEWFOLDER ]
                then
                        echo "New name: $NEWFOLDER"
                        mv "$folder" $NEWFOLDER
                fi
                echo "Creating Folder: $NEWFOLDER"
                ZCSPATH=${NEWFOLDER#"./"}
                echo "ZCS Path: $ZCSPATH"
                TMPPATH=""
                IFS='/'
                for TPATH in $ZCSPATH
                do
                        if [ $TPATH != "" ]
                        then
                                echo "Creating Path: $TMPPATH/$TPATH"
                                echo createFolder $TMPPATH/$TPATH | zmmailbox -z -m $ZCSACCOUNT
                                TMPPATH=$TMPPATH/$TPATH
                        fi
                done
                IFS=$'\n'
                for file in $(find $NEWFOLDER)
                do
                        FILENAME=${file#"$NEWFOLDER/"}
                        NEWFILE=`newName $FILENAME`
                        echo "Current File: $NEWFOLDER/$FILENAME"
                        if [ "$FILENAME" != $NEWFILE ]
                        then
                                echo "New name: $NEWFILE"
                                mv "$NEWFOLDER/$FILENAME" "$NEWFOLDER/$NEWFILE"
                        fi
                        case $NEWFOLDER/$NEWFILE in
                                *.eml)
                                        echo "Found E-Mail: $NEWFOLDER/$NEWFILE"
                                        echo addMessage $ZCSPATH $NEWFOLDER/$NEWFILE | zmmailbox -z -m $ZCSACCOUNT
                                ;;
                                *)
                                        echo "Found Unknown file: $NEWFOLDER/$NEWFILE"
                                ;;
                        esac
                done
        fi
done
