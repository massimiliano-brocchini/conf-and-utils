#!/bin/sh

FILE=$1

BEFORE=$2
B_NUM=$3

AFTER=$4
A_NUM=$5

INIZIO_TAGLIO=`cat $FILE | grep -n "$BEFORE" | cut -d ":" -f 1 | sed -n "${B_NUM}p"`

OFFSET=$((`cat $FILE | sed "1,$(($INIZIO_TAGLIO-1))d" | grep -n "$AFTER" | cut -d ":" -f 1 | sed -n "${A_NUM}p"`-1))

FINE_TAGLIO=$(($INIZIO_TAGLIO+$OFFSET))

cat $FILE | sed -n "${INIZIO_TAGLIO},${FINE_TAGLIO}p" | sed "s_.*${BEFORE}\|${AFTER}.*__g"
