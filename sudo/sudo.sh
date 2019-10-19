#!/usr/bin/env bash
pname sudo/sudo

islaptop() {
    if $(sudo dmidecode --string chassis-type) | grep -i 'laptop'; then
        echo "is running on a laptop"
        return 0
    else
        echo "not running on a laptop"
        return 1
    fi
}
