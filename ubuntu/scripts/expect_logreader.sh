#! /usr/bin/expect --

set user "logreader"
# !!!!!!!!!!! set password !!!!!!!!!!!
set pass ""
set serv [lindex $argv 0]
set rid [lindex $argv 1]
set login_error 1

set et_log_dir "/cygdrive/d/anx/var/log/EasyTravel/2.13"
set result_file $serv-$rid.txt
set today [exec date "+%Y%m%d"]
set search_log_file log$today.txt
set result_file_path $et_log_dir/$result_file
set log_parser "/cygdrive/d/anx/bin/tool/logparser/logparser.exe"

spawn ssh $user@$serv
set timeout 2
expect "continue connecting (yes/no)?" {
    send "yes\r"
    sleep 4
}

set timeout 10
expect {
  "password:" {
    send "$pass\r" 
    # sleep command is necessary to wait for the end of login process.
    sleep 1
  }
  timeout {
    puts "\n$serv timeout - login faile"
    sleep 1
    exit $login_error
  }
}

expect {
  "Last login:" { 
    puts "\n$serv login succeeded"
    puts "start searching..."
    sleep 1
  }
  "Permission denied" { 
    puts "\n$serv permission denied - login faile"
    sleep 1
    exit $login_error
  }
}


log_user 0
log_file -noappend -a $result_file
send "cd $et_log_dir\r"
send "$log_parser -u full -f $search_log_file -t \"\[\\r\\n;{$rid};\\r\\n\];\" -v\r"
# wait for the search result max 180 seconds
set timeout 180
expect {
  "Elapsed time:" {
    log_user 1
    puts "$serv Process finished"
    sleep 1
  }
  "does not exist" {
    log_user 1
    puts "$serv File does not exist"
    sleep 1
  }
  timeout {
    puts "\n$serv timeout - searching"
    sleep 1
  }
}

send "exit\r"
expect eof

