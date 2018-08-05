#!/bin/bash
#this sets up rclone without installing it via package management
setuprclone(){
  RCLONEDIR=~/.paperbenni/rclone/rclone
  export PATH="$RCLONEDIR:${PATH}"
}
