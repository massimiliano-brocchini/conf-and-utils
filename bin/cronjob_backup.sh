#!/bin/zsh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

f=/srv/http/spese/spese.sqlite
c=/srv/http/spese/last_backup

if [[ ! -e $c || $c -ot $f ]]; then
	/home/salotto/backup_to_email.sh $f && touch $c
fi

f=/srv/http/scontrini/scontrini.sqlite
c=/srv/http/scontrini/last_backup

if [[ ! -e $c || $c -ot $f ]]; then
	/home/salotto/backup_to_email.sh $f && touch $c
fi
