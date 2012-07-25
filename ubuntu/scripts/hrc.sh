#! /bin/bash

# arguments description
# $1 - rid, tid etc. = data to find
# $2 - true = run each serching process in apart terminal

data=$1
new_terminal=${2-false}

servers=( '192.168.194.20' )
servers_len=${#servers[@]}

echo passed args: $@

for (( i = 0; i < $servers_len; i++ )); do
  server=${servers[${i}]}

  if [ $new_terminal = true ]; then
    gnome-terminal -x ./expect_logreader.sh $server $data &
  else
    ./expect_logreader.sh $server $data &
  fi

done
