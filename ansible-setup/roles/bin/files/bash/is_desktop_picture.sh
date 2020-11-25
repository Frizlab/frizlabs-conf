#!/bin/bash

set -e

image=$1
desktop_width=$2
desktop_height=$3
aspect_ratio_leeway=$4
if [ -z "$image" -o -z "$desktop_width" -o -z "$desktop_height" -o -z "$aspect_ratio_leeway" ]; then
	echo "usage: $0 image desktop_width desktop_height aspect_ratio_leeway" >/dev/stderr
	exit 1
fi

w=$(sips -g pixelWidth  "$image" | tail -n+2 | cut -d: -f2)
h=$(sips -g pixelHeight "$image" | tail -n+2 | cut -d: -f2)
exit "$(bc <<<"scale=150;   v=$w/$h - $desktop_width/$desktop_height;   sqrt(v*v) > $aspect_ratio_leeway")"
