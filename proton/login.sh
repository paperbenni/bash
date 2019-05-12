#!/usr/bin/expect -f

# log into the otherwise interactive ProtonVPN from a bash script
set timeout -20
set username [lindex $argv 0];
set password [lindex $argv 1];

spawn pvpn --init

expect "*username*"
send "$username\r"
expect "*password*"
send "$password\r"
expect "*ProtonVPN*"
send "1\r"
sleep 1
send "\r"
sleep 1
send "\r"
expect eof
