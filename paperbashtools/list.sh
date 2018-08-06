#!/bin/bash
paperbashbuild(){
 for THISFILE in $(find . -type f -not -path "*.git/*")
 do
 THISLINE=${THISFILE:2}
 echo $THISLINE >> packages.paperbash
 done
}
