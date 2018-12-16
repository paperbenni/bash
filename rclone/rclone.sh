#!/bin/bash
#this sets up rclone without installing it via package management

rdropbox() {
	pushd $HOME
	mkdir -p .config/rclone
  echo "[dropbox]
        type = dropbox
        token = {\"access_token\":\"$1\",\"token_type\":\"bearer\",\"expiry\":\"0001-01-01T00:00:00Z\"}" >> rclone.conf
  popd
}

rclonedl() {
	pushd $HOME
	mkdir rclone
	cd rclone
	wget https://github.com/paperbenni/bash/blob/master/rclone/rclone/rclone
	chmod +x rclone
	popd
	RCLONEDIR=~/.paperbenni/rclone/rclone
	export PATH="$RCLONEDIR:${PATH}"
}

rload() {
        rclone copy dropbox:"$1" ./"$1"
}