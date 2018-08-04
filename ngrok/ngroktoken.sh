#!/bin/bash
curl "https://raw.githubusercontent.com/paperbenni/ngrok.sh/master/tokens.txt" > ./ngroktokens.txt
shuf -n 1 ./ngroktokens.txt > token.txt
rm ./ngroktokens.txt
cat token.txt
echo "TOKEN set"
