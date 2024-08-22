#!/bin/sh
set -eu
file="$TARGET/.config/mpv/platform.conf"
echo "ensuring $file exists..."
touch "$file"
