#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

d=${1:-"."}
f=${2:-"$d/.file_permissions"}

cd $d

cat $f | while read perm user group x; do 
	chmod $perm $x && chown $user:$group $x
done
