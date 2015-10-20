#!/bin/zsh

set -u

CONFIG_FILE="/home/$(whoami)/.max_wm/default_size"

WIN_ID=$( xprop -root | /bin/grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d ' ' -f 5)

WIN_CLASS=$( xprop -id $WIN_ID WM_CLASS | cut -d ',' -f 2 | sed -e "s/\"//g" | sed -e "s/ //g")

SIZE=$( /bin/grep -i $WIN_CLASS $CONFIG_FILE | /bin/egrep -io "[0-9]*,[0-9]*"  )

if [ -n "$SIZE" ]; then
	/usr/bin/wmctrl -i -r $WIN_ID -b remove,maximized_vert,maximized_horz
	eval  "/usr/bin/wmctrl -i -r $WIN_ID -e 0,-1,-1,$SIZE"
else
	INFO=$( /usr/bin/xwininfo -id $WIN_ID )	
	WIDTH=$(echo $INFO | /bin/grep Width | /bin/egrep -o "[0-9]+")
	HEIGHT=$(echo $INFO | /bin/grep Height | /bin/egrep -o "[0-9]+")
	DEFAULT=$( /usr/bin/zenity --entry --text="Dimensioni di default per $WIN_CLASS" --entry-text="$WIDTH,$HEIGHT" )
	if [ -n "$DEFAULT" ]; then
		echo "$WIN_CLASS $DEFAULT" >> $CONFIG_FILE
	fi
fi

set +u
