#!/bin/zsh

#prende come argomento lo spostamento relativo dal monitor di partenza (di solito 1 -1)

#aggiustamento per la differenza fra wmctrl -i -r ID -e 0,0,0,-1,-1 e wmctrl -l -G | grep ID per l'origine delle coordinate
center_offset_X=4
center_offset_Y=20

zmodload zsh/mathfunc

set -u

#array associativi dimensioni in pixel dei monitor
#gli array devono essere associativi perche' i monitor si contano a partire da 0, ma gli array in zsh partono da 1
typeset -A monitor_X
typeset -A monitor_Y
monitor_X=(0 1600 1 1280)
monitor_Y=(0 1200 1 1024)
TOT_MONITOR=$(( $#monitor_X-1 ))

#id finestra attiva
activeWinID=$( xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5)
#informazioni finestra attiva
INFO=$( /usr/bin/xwininfo -id $activeWinID )	
WIDTH=$(echo $INFO | /bin/grep Width | /bin/egrep -o "[0-9]+")
HEIGHT=$(echo $INFO | /bin/grep Height | /bin/egrep -o "[0-9]+")
POS_X=$(( $(echo $INFO | /bin/grep 'Absolute upper-left X' | /bin/egrep -o "[0-9]+") - $center_offset_X ))
POS_Y=$(( $(echo $INFO | /bin/grep 'Absolute upper-left Y' | /bin/egrep -o "[0-9]+") - $center_offset_Y ))

#monitor con focus
MONITOR=$( xprop -id $activeWinID __E_WINDOW_ZONE | cut -d ' ' -f 3 )


#elimino il + dal parametro
PARAM=${1/+/}

#monitor di destinazione
DEST=$(( $MONITOR+$PARAM ))


if [[ $DEST -gt $TOT_MONITOR ]]; then
	DEST=$TOT_MONITOR
fi

if [[ $DEST -lt 0 ]]; then
	DEST=0
fi

#calcolo aspect ratio

ratio_X=$(( $monitor_X[$MONITOR].0/$monitor_X[$DEST].0 ))
ratio_Y=$(( $monitor_Y[$MONITOR].0/$monitor_Y[$DEST].0 ))


echo $ratio_X

INCR=1
if [[ $PARAM -lt 0 ]]; then
	INCR=-1
fi

DELTA=$(( abs($MONITOR-$DEST) ))
SPOSTAMENTO=0

for ((ct=0; ct<$DELTA; ct++)); do
	i=$(( $MONITOR+($ct*$INCR) ))
	SPOSTAMENTO=$(( SPOSTAMENTO + $monitor_X[$i] ))
done


#---check maximization
winState=$( xprop -id ${activeWinID} _NET_WM_STATE )

maxH=0
maxV=0
fulls=0

if [[ `echo ${winState} | grep "_NET_WM_STATE_MAXIMIZED_HORZ"` != "" ]]
   then
   maxH=1
   wmctrl -i -r ${activeWinID} -b remove,maximized_horz
fi

if [[ `echo ${winState} | grep "_NET_WM_STATE_MAXIMIZED_VERT"` != "" ]]
   then
   maxV=1
   wmctrl -i -r ${activeWinID} -b remove,maximized_vert
fi

if [[ `echo ${winState} | grep "_NET_WM_STATE_FULLSCREEN"` != "" ]]
   then
   fulls=1
   wmctrl -i -r ${activeWinID} -b remove,fullscreen
fi
#---

# move window
echo wmctrl -i -r ${activeWinID} -e 0,$(( int($POS_X * $ratio_X + ($INCR * $SPOSTAMENTO)) )),$(( int($POS_Y * $ratio_Y) )),-1,-1
echo wmctrl -i -r ${activeWinID} -e 0,$(( int($POS_X + ($INCR * $SPOSTAMENTO)) )),$(( int($POS_Y) )),-1,-1

((${maxV})) && wmctrl -i -r ${activeWinID} -b add,maximized_vert
((${maxH})) && wmctrl -i -r ${activeWinID} -b add,maximized_horz
((${fulls})) && wmctrl -i -r ${activeWinID} -b add,fullscreen

# raise window (seems to be necessary sometimes)
wmctrl -i -a ${activeWinID}

set +u

exit 0
