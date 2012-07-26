#! /usr/bin/expect -f

set server    [lindex $argv 0]
set port      "11211"
set filePath  [lindex $argv 1]
set logFile   "memcached-infx.txt"

spawn telnet $server $port
set timeout 5
expect "Connected to" { 
  send_user "stats - before adding infx\n"
	send "stats\r" 
	sleep 1
}


log_user 1
log_file -a -noappend $logFile
send_user "start reading - file with package data\n"
if [catch {open $filePath "r"} fhandle] {
  send_user "$fhandle\n"
  return
}

while { [gets $fhandle line] >= 0} {
  set key [lindex $line 0][lindex "1_part0" 0]
  set value [lindex $line 1]
  set value_len [string length "$value"]
  set mem_command "set $key 0 60 $value_len\r"

  send_user "********************************************************\n"
  send $mem_command
  send "$value\r"
  
  # in this case, expect waits for the confirmation from memcached about the storage status.
  expect {
    "STORED" { puts "OK" }
    "ERROR" { puts "ERROR" }
  }
}
close $fhandle
send_user "end reading - file with package data\n"

send_user "stats - after adding infx\n"
send "stats\r"

send "quit\r"
expect eof