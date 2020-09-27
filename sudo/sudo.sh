#!/usr/bin/env bash
pname sudo/sudo

islaptop() {
    #printf "ERROR: Root privileges are required for this operation.\n"
    [ $UID -eq 0 ] || return 1

    buff="$(dmidecode --string chassis-type)"
    if [[ "$buff" == [lL]aptop ]]; then
        echo "is running on a laptop"
    elif [[ "$buff" == [dD]esktop ]]; then
        echo "running on a desktop"
    else
        echo "unidentifiable chassis type" >&2
	return 1
    fi
}
