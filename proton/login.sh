#!/usr/bin/expect -f

set timeout -20
set rootpass [lindex $argv 0];
set username [lindex $argv 1];
set password [lindex $argv 2];

spawn sudo pvpn --init
sleep 1
send "$rootpass\r"

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
