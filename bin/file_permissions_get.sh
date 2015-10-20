#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

d=${1:-"."}
f=${2:-"$d/.file_permissions"}

find $d -printf "%m %U %G " -ls | sed -e 's#[[:blank:]]\+# #g' | cut -d ' ' -f 1,2,3,14- > $f
