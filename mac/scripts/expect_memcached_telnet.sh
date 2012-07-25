#! /usr/bin/expect -f

set server 		"127.0.0.1"
set port 		"11211"
set fileToRead 	[lindex $argv 0]

spawn telnet $server $port
set timeout 5
expect "Connected to" { 
	send "stats\r" 
	sleep 2
}



send "stats\r"

send "quit\r"
expect eof