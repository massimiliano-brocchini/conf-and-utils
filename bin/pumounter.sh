#!/bin/sh
/bin/mount | /bin/grep '/media/' | /bin/cut -d ' ' -f 3 | /usr/bin/xargs /usr/bin/pumount
