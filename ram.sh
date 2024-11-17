#!/bin/bash


mem=$(free -g | awk 'NR==2 {print int($3)}')

if [[ $mem -ge 2 ]];then
  notify-send "you are going to die very soon"
fi

if [[ $mem -ge 6 ]]; then
  pid=$(ps -u $USER -o pid,%mem --sort=-%mem | awk 'NR==2 {print $1}')

  if [[ -z "$pid" ]]; then
    echo "No processes found"
    exit 1
    
  fi
  
  choice=$(echo -e "YES\nNO" | wofi -d -p "Your memory usage is high, do want to kill the top process?" )
  if [[ $choice = "YES" ]]; then
    echo "Killing the process $pid"
    kill -9 $pid | notify-send "Now the RAM is free "
  else
    echo "keep the process"
  fi
fi


