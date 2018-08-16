#!/bin/bash

pbuild() {
	case $1 in
		packages)

		if [ -e packages.paperbash ]
		then
			rm packages.paperbash
		fi
		for THISFILE in $(find . -type f -not -path "*.git/*"); do
			THISLINE=${THISFILE:2}
			echo $THISLINE >> packages.paperbash
		done

			;;
		ref)
			if [ "$2" = "-r" ]
			then
				if [ -e "$3" ]
					rm "$3"
					echo "removed $3"
				else
					echo "file $3 not found"
				fi
			fi
			if [ -n "$2" ] && [ -n "$3" ]
			then
				echo "$3" > "$2.paperref"
				echo "added reference for $2"
			fi
			;;

		esac
	}
