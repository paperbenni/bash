#!/bin/bash

ngrok() {
    mkdir -p ~/.ngrok2
    if ! ~/ngrok/ngrok --version; then
        mkdir -p ~/ngrok
        pushd ngrok
        wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
        chmod +x ngrok
        if ! ./ngrok --version; then
            echo "failed"
            exit 1
        fi
        popd
    fi
    
    while true; do
        curl "https://raw.githubusercontent.com/paperbenni/ngrok-docker/master/tokens.txt" >./ngroktokens.txt
        ~/ngrok/ngrok authtoken $(shuf -n 1 ./ngroktokens.txt)
        rm ./ngroktokens.txt
        sleep 5
        ~/ngrok/ngrok "$@"
        sleep 5
    done

}

getgrok() {
    echo "getting ngrok adress..."
    curl -s localhost:4040/inspect/http | grep -oP 'window.common[^;]+' | sed 's/^[^\(]*("//' | sed 's/")\s*$//' | sed 's/\\"/"/g' | jq -r ".Session.Tunnels | values | map(.URL) | .[]" | grep "^tcp://" | sed 's/tcp\?:\/\///' >ngrokadress.txt
}
