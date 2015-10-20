#!/bin/zsh

A=Front
B=Surround

if [ -n "$(amixer get $A | grep '\[on\]')" ]; then PARAM=mute; fi
if [ -n "$(amixer get $A | grep '\[off\]')" ]; then PARAM=unmute; fi

amixer set $A $PARAM &> /dev/null

if [ -n "$(amixer get $B | grep '\[on\]')" ]; then PARAM=mute; fi
if [ -n "$(amixer get $B | grep '\[off\]')" ]; then PARAM=unmute; fi

amixer set $B $PARAM &> /dev/null
