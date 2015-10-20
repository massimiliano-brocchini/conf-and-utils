#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

SSH=

rsync_command &
pid=$!
sleep 110m
kill $pid

if [[ -n $(ssh $SSH "if [[ -f /tmp/PLANNED_SHUTDOWN ]]; then echo S; fi") ]]; then
	ssh $SSH "/usr/bin/systemctl poweroff"
fi
