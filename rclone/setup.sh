#!/bin/bash
if [ -e .config/rclone/rclone.conf ]
then
  echo "rclone.conf found"
  cd .config/rclone
else
  mkdir -p .config/rclone
  cd .config/rclone
  touch rclone.conf
  echo "rclone.conf created"
fi

if grep -q rclonesh rclone.conf; then
  echo "storage found"
  else
  curl https://raw.githubusercontent.com/paperbenni/rclone/master/rclone.conf >> rclone.conf
  rpstring name rclonesh
  rpstring geheimtoken MAv30X0vpPAAAAAAAAAACKpBiXHzAIdqPdRDFJ9ZbPAV1S8qohwVV4UZAZZUJEmf 
fi
