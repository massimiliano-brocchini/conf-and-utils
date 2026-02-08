#!/bin/zsh

src=$1
dst="${src%%.*}.avi"
m=$(mediainfo --Output="Video;%CodecID%" "$src")

if [[  "$m" == "MJPG" || "$m" == "avc1" ]]; then
	d=$(stat -c %y $src)

	ffmpeg -threads "$(cat /proc/cpuinfo | grep "^processor" | wc -l)" -i "$src" -vcodec libx264 "$dst"
	touch --date="$d" "$dst"
	mv "$src" "$src.orig"
fi
