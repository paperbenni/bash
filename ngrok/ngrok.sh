#!/bin/bash

gitexe() {
        curl https://raw.githubusercontent.com/paperbenni/"$1"/master/"$2".sh | bash
}


gitexe ngrok.sh ngroktoken

curl -o ngrok https://raw.githubusercontent.com/paperbenni/ngrok.sh/master/ngrok

TOKEN=$(cat ./token.txt)
chmod +x ./ngrok || echo "please set perm manually"
./ngrok authtoken "$TOKEN"

while : 
do
        if [ -f ngrokport.txt ]
        then
                ./ngrok tcp "$(cat ngrokport.txt)"
        else
                ./ngrok tcp 25565
        fi
        sleep 1
done
