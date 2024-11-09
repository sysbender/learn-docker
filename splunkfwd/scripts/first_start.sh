#!/usr/bin/expect -f
set timeout -1
spawn /opt/splunkforwarder/bin/splunk start --accept-license 
expect "Please enter an administrator username: "
send -- "admin\r"
expect "Please enter a new password: "
send -- "changemoi\r"
expect "Please confirm new password: "
send -- "changemoi\r"
expect eof