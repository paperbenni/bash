#!/usr/bin/expect -f
set username [lindex $argv 0]
set password [lindex $argv 1]

set timeout -1

spawn heroku login -i
sleep 3
expect ":"
send "$username\r"
expect "d:"
send "$password"
sleep 1
send "\r"
expect eof
