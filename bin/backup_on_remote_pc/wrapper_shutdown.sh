#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

cmd=$(basename $0)

_dialog() {
	if [[ -n "$DISPLAY" ]]; then
		zenity --question --title "Alert" --text "$1" --ok-label "$2" --cancel-label "$3"
	else 
		dialog --yes-label "$2" --no-label "$3" --yesno "$1" 20 40 
	fi
}

_shutdown() {
	if [[ -n "$DISPLAY" ]]; then
		wmctrl -l | while read w _x; do wmctrl -i -c $w; done
	fi
	systemctl poweroff
}

ct_users=$(who -u | cut -d ' ' -f 1 | uniq | wc -l)

if _dialog "Spengere il computer" "Si" "No"; then
	if [[ $ct_users > "1" ]]; then
		if _dialog 'Altri utenti collegati al computer, scegliere: \n - SPENGI per forzare spengimento adesso. \n - AUTO per spengimento automatico entro 2 ore' "AUTO" "SPENGI"; then
			touch /tmp/PLANNED_SHUTDOWN
			echo 'systemctl poweroff' | at now + 2 hours
		else
			_shutdown
		fi
		exit 0
	fi
	_shutdown
fi
