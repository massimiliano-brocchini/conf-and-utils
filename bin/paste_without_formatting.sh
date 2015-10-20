#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

xsel -o -b | xsel -i -b
xdotool getactivewindow key --delay 2 ctrl+v
