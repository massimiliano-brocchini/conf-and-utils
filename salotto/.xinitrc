[[ -f ~/.Xresources ]] && xrdb ~/.Xresources
solaar config 1 fn-swap False &
numlockx &
setxkbmap it &
xinput set-prop $(xinput list | pcregrep -o1 'K400.*id=(\d+).*pointer') "libinput Middle Emulation Enabled" 1 &
exec /usr/bin/awesome --no-argb >> /tmp/awesome.log 2>> /tmp/awesome.err
