#!/bin/bash
mediafire() {
	if [ -n "$1" ]; then
		echo $1 >mediafire.txt
		bash ~/.paperbash/rclone/mediafire/mediafire mediafire.txt
		rm mediafire.txt
		rm mediafiredownload.sh
	else
		echo "usage: mediafire [mediafire-link]"
	fi
}
