#!/bin/zsh

while xset q | grep "Monitor is Off" > /dev/null ; do
	sleep 1m
done
rm -f /tmp/force_monitor_sleep
