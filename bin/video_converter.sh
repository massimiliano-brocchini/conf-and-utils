#!/bin/zsh

f=$1
m=$(mediainfo --Output="Video;%CodecID%" "$f")

if [[  "$m" == "MJPG" || "$m" == "avc1" ]]; then
	d=$(stat -c %y $f)

	mv "$f" "$f.orig"
	ffmpeg -threads "$(cat /proc/cpuinfo | grep "^processor" | wc -l)" -i "$f.orig" -vcodec libx264 "${f%%.*}.avi"
	touch --date="$d" "$f"
fi
