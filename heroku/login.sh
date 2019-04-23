#!/usr/bin/expect -f

# log into the otherwise interactive ProtonVPN from a bash script

set timeout -20
set username [lindex $argv 0];
set password [lindex $argv 1];

spawn heroku login -i

expect "*mail*"
send "$username\r"
expect "*assword*"
send "$password\r"
sleep 3
