#!/usr/bin/env bash
pname reddit/reddit
pb grep

rdsubmissions() {

    PUSHSHIFT="https://api.pushshift.io/reddit/submission/search/?subreddit"
    curl "$PUSHSHIFT=$1&num_comments=>100&sort=desc&filter=created_utc,id,title,score&size=1000" >push.txt

    RDLIMIT=${2:-1000}
    if [ $RDLIMIT -gt 2000 ]; then
        RDCOUNT=$(($RDLIMIT / 2000))
    else
        RDCOUNT=2
    fi

    echo "fetching $RDCOUNT pages"
    #get the last time
    for i in $(seq $RDCOUNT); do
        #statements
        LASTTIME=$(cat push.txt | tail -8 | grep '"created_utc"' | egrep -o '[0-9]*')
        echo "after $LASTTIME"
        curl "$PUSHSHIFT=$1&num_comments=>10&sort=desc&filter=created_utc,id,score&size=1000&before=$LASTTIME" >>push.txt
        sleep 1
    done
}

rdid() {
    cat "$1" | egrep '"id"' | egrep -o ':.*' | betweenquotes >"$2.2"
    sort -u "$2.2" >"$2"
    rm "$2.2"
}
