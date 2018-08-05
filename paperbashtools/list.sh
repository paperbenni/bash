#!/bin/bash
paperbash(){
 for THISFILE in $(find .)
 do
 THISLINE=${THISFILE:2}
 echo $THISLINE >> packages.paperbash
 done
}