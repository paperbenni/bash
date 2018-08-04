#!/usr/bin/env bash

        ix() {
            local opts
            local OPTIND
            [ -f "$HOME/.netrc" ] && opts='-n'
            while getopts ":hd:i:n:" x; do
                case $x in
                    h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
                    d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
                    i) opts="$opts -X PUT"; local id="$OPTARG";;
                    n) opts="$opts -F read:1=$OPTARG";;
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
        
if [ -f ix.txt ]
then
        IXCONTENT=$(cat ix.txt)
        if [ -f ixid.txt ]
        then
                IXID=$(cat ixid.txt)
                echo $IXCONTENT | ix -i "$IXID"
        else
                echo "ixid.txt missing"
                sleep 1
                echo account create | ix
                echo "creating ix.io website..."
                echo $IXCONTENT | ix > ixid.txt
                sed -e "s/http:\/\/ix.io\///g" -i ixid.txt

        fi

else
        echo "ix.txt missing"
fi

