#!/usr/bin/env bash
pname reddit/reddit

rdsubmissions() {

    PUSHSHIFT="https://api.pushshift.io/reddit/submission/search/?subreddit"
    curl "$PUSHSHIFT=$1&num_comments=>100&sort=desc&filter=created_utc,id,title,score&size=1000" >push.txt
    #get the last time
    for ((i = 0; i < 10; i++)); do
        #statements
        LASTTIME=$(cat push.txt | tail -8 | grep '"created_utc"' | egrep -o '[0-9]*')
        echo "$LASTTIME"
        curl "$PUSHSHIFT=$1&num_comments=>100&sort=desc&filter=created_utc,id,title,score&size=1000&before=$LASTTIME" >>push.txt
    done
}

rdid() {
    pb grep
    cat "$1" | egrep '"id"' | egrep -o ':.*' | betweenquotes >"$2.2"
    sort -u "$2.2" >"$2"
    rm "$2.2"
}
