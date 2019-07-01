#!/usr/bin/env bash
pname ix/ix
# this is the ix function from ix.io
ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
        h)
            echo "ix [-d ID] [-i ID] [-n N] [opts]"
            return
            ;;
        d)
            $echo curl $opts -X DELETE ix.io/$OPTARG
            return
            ;;
        i)
            opts="$opts -X PUT"
            local id="$OPTARG"
            ;;
        n) opts="$opts -F read:1=$OPTARG" ;;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            curl $opts -F f:1=@"$filename" $* ix.io/$id
            return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}

#usage: ixlogin {username} {password}
ixlogin() {
    if [ -z "$2" ]; then
        IXUSERNAME="paperbennitester"
        IXPASSWORD="paperbennitester"
    else
        IXUSERNAME="$1"
        IXPASSWORD="$2"
    fi
    pushd $HOME
    echo "machine ix.io" >.netrc
    echo "    login $IXUSERNAME" >>.netrc
    echo "    password $IXPASSWORD" >>.netrc
    popd
    echo "logged in"
}

ixrun() {
    if [ -z "$1" ]; then
        IXCONTENT="test"
    else
        IXCONTENT="$1"
    fi

    if [ -d ~/ixid.txt ]; then
        rm -rf ~/ixid.txt
    fi

    if [ -e ~/ixid.txt ]; then
        IXID=$(cat ~/ixid.txt)
        echo $IXCONTENT | ix -i "$IXID"
    else
        echo "ixid.txt missing"
        echo "creating ix.io website..."
        sleep 1
        echo $IXCONTENT | ix >ixidtemp.txt
        sed -e "s/http:\/\/ix.io\///g" <ixidtemp.txt >ixid2.txt
        REMOVETHIS=$(cat ixid2.txt | grep -o 'user .*added')
        IXCONTENT=$(cat ixid2.txt)
        rm ixid2.txt ixidtemp.txt
        echo ${IXCONTENT#$REMOVETHIS} >~/ixid.txt

    fi
    echo "ix content $IXCONTENT"
    echo "your id is $(cat ~/ixid.txt)"

}
