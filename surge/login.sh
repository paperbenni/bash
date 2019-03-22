#!/usr/bin/expect -f

set timeout -20
set email [lindex $argv 0]
set password [lindex $argv 1]

spawn surge login

expect "*email*"
send "$email\r"
expect "*password*"
send "$password\r"
sleep 2
expect eof
