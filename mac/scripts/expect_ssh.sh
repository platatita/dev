#! /usr/bin/expect -f
# the script presents you how to use the 'expect' to autologin into remote server and provide password.

set timeout 60

set user  [lindex $argv 0]
set serv  [lindex $argv 1]
set pass  [lindex $argv 2]
set comm  [lindex $argv 3]

spawn ssh $user@$serv
expect "password:" { send "$pass\r" }
send "$comm\r"

# display to the user infos
send_user "\n"
# display only the expected word in the case "password:"
send_user "expect_out(0,string): $expect_out(0,string)\n"
# display whole text which appeared before the expected word "password:"
send_user "expect_out(buffer): $expect_out(buffer)\n"
# sleep for 10 seconds
sleep 10

# switch off below two lines if you want use interact mode
send "exit\r"
expect eof

# switch on if you want to put any command after login
# interact