#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

xsel -o -b | xsel -i -b

if [[ -n "$1" ]]; then
	xdotool key --window $1 --delay 2 ctrl+v
else
	xdotool selectwindow key --delay 2 ctrl+v
fi
