# paperbegin
#################################
## paperbash debugging utility ##
#################################

papertest() {
    if ! [ -e ~/workspace/bash/import.sh ]; then
        if ! curl cht.sh &>/dev/null; then
            echo "no internet"
            return 1
        fi
        mkdir -p ~/workspace/bash
        curl "https://raw.githubusercontent.com/paperbenni/bash/master/import.sh" >~/workspace/bash/import.sh
    fi
    source ~/workspace/bash/import.sh
}
# paperend
