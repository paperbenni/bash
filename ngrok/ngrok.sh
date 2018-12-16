#!/bin/bash

# Downloads ngrok
# usage: ngrokdl {token}
ngrokdl() {
	pushd $HOME
	mkdir ngrok
	cd ngrok
	wget https://github.com/paperbenni/bash/raw/master/ngrok/ngrok
	chmod +x ngrok
	./ngrok authtoken "$TOKEN"
	popd
}

ngrok() {
	$HOME/ngrok/ngrok "$@"
}

minegrok() {
	if ! ngrok --version; then
		echo "ngrok not installed"
		exit 1
	fi
	while :; do
		./ngrok tcp 25565
		sleep 1
		ngrok authtoken $(ngroktoken)
	done &
	echo "ngrok started"
	popd
}

# puts an ngrok token to stdout
ngroktoken() {
	curl "https://raw.githubusercontent.com/paperbenni/ngrok.sh/master/tokens.txt" >./ngroktokens.txt
	shuf -n 1 ./ngroktokens.txt >token.txt
	rm ./ngroktokens.txt >/dev/null
	cat token.txt
}

# gets the running ngrok adress
getgrok() {
	curl -s localhost:4040/inspect/http | grep -oP 'window.common[^;]+' | sed 's/^[^\(]*("//' | sed 's/")\s*$//' | sed 's/\\"/"/g' | jq -r ".Session.Tunnels | values | map(.URL) | .[]" | grep "^tcp://" | sed 's/tcp\?:\/\///'
}
