#!/bin/bash

ngrok(){
pushd ~/.paperbenni/ngrok
bash ./ngroktoken.sh
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
done &
echo "ngrok started"
popd
}

