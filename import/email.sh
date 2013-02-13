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
                ZCSPATH=${NEWFOLDER#"."}
                arr=$(echo $ZCSPATH | tr "/" "\n")
                for path in $arr
                do
                        echo "Creating Path: $TMPPATH/$PATH"
                        echo createFolder $TMPPATH/$PATH | zmmailbox -z -m $ZCSACCOUNT
                        TMPPATH=$TMPPATH/$PATH
                done
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
