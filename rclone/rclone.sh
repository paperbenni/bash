#this sets up rclone without installing it via package management
RCLONEDIR=$(pwd)/rclone
mkdir rclone
cd rclone
curl -o rclone https://github.com/paperbenni/rclone/raw/master/rclone
curl https://raw.githubusercontent.com/paperbenni/rclone/master/rclone.1 > rclone.1
export PATH="$RCLONEDIR:${PATH}"
