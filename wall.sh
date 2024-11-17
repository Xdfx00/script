#!/bin/bash

wal=$(find /home/amaan/Pictures -name "*.jpg" -o  -name "*.png"  | shuf -n1)

if [[ $(pidof swww) ]]
then 
  pkill swww
fi

swww img $wal --transition-type grow --transition-fps 60 --transition-duration 0.5 --transition-bezier 0.65,0,0.35,1 --transition-pos 0.794,0.972 --transition-step 1 | notify-send "Wallpaper has changed"
#swaygb -i $wal -m fit | notify-send "Wallpaper has changed"



sleep 1.25

if [[ "$(<~/.cache/wal/mode)" = "dark" ]]; then
  wal -i $wal --cols16
elif [[ "$(<~/.cache/wal/mode)" = "light" ]]; then
  wal -i $wal -l --cols16
fi

pywal-discord -t default
pywalfox update
wal-telegram --wal


. $HOME/.config/mako/update-colors.sh
