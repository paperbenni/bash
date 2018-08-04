#!/bin/bash

#import functions
curl "https://raw.githubusercontent.com/paperbenni/bash/master/bash.sh" > .bashfunctions.sh
source .bashfunctions.sh

#setup ix.io account
echo "machine ix.io" > .netrc
echo "    login $ACCOUNTNAME" >> .netrc
echo "    password $ACCOUNTPASSWORD" >> .netrc

mkdir .ngrok2

gitexe ngrok.sh ngrok &

while :
do
        gitexe ngrok.sh getgrok &
        mv ngrokadress.txt ix.txt
        gitexe ix.io ix
        IXID=$(cat ixid.txt)
        echo "Your Server ID is $IXID"
        sleep 2m
done &

echo "attempting login"


mkcd "$ACCOUNTNAME"

rclone copy dropbox:"$ACCOUNTNAME"/password.txt ./

if [ -e password.txt ]; then #account exists
        DROPBOXPASSWORD=$(cat ./password.txt)
        if [ "$ACCOUNTPASSWORD" = "$DROPBOXPASSWORD" ] #password correct
        then
                echo "login successfull!"
                rclone copy dropbox:"$ACCOUNTNAME" ./"$ACCOUNTNAME" #download account data
        else #wrong password
                yess "wrong password or Username already taken"
        fi
else #make new account
    mkdir -p spigot/plugins
    echo "$ACCOUNTPASSWORD" > password.txt
    rclone copy ../"$ACCOUNTNAME" dropbox:"$ACCOUNTNAME"
    echo "Account $ACCOUNTNAME created!"
fi


cd spigot || ( mkdir -p spigot && cd spigot || echo "bruh" )


while :
do #start spigot
        gitexe spigot.sh spigot
        rm -rf cache
        rm spigot.jar
        rclone copy ../../"$ACCOUNTNAME" dropbox:"$ACCOUNTNAME"
        echo "restarting loop"
        sleep 5
        if [ -n "$GITREPO" ]
        then
                echo "$GITREPO" > git.txt
                gitexe spigot.sh override
        fi
        sleep 2

done

echo 'quitting server :('
#end of script

