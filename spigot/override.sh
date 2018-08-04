#!/bin/bash

replace() {
  if [ -e ./"$1" ]
  then
    if [ -e ../"$1" ]
    then
      rm ../"$1"
    else
      echo "parent dir clean"
    fi
    mv ./"$1" ../"$1"
  else
    echo "skipping $1"
  fi
}

GITREPO=$(cat git.txt)
mkdir gitspigot
cd gitspigot
git clone https://github.com/"$GITREPO".git .

for file in ./*; do
  echo "$file"
  replace "$file"
done

cd ..
rm gitspigot
echo "done"
