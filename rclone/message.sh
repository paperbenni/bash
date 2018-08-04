#!/bin/bash
rsend(){
echo $1 > $2
rclone copy $2 rclonesh:$2 > /dev/null
rm $1 > /dev/null
}
rread(){
rclone copy rclonesh:$1 . > /dev/null
cat $1
rm $1 > /dev/null
}
