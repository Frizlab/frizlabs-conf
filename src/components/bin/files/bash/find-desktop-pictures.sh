#!/bin/bash

searched_folder="$1"
desktop_width=$2
desktop_height=$3
aspect_ratio_leeway=$4
find_action=${5:--print}
if [ -z "$searched_folder" -o -z "$desktop_width" -o -z "$desktop_height" -o -z "$aspect_ratio_leeway" ]; then
	echo "usage: $0 folder desktop_width desktop_height aspect_ratio_leeway [find_action]" >&2
	exit 1
fi

is_desktop_pic="$(which "is-desktop-picture")"
if [ ! -x "$is_desktop_pic" ]; then
	echo "could not find the is-desktop-picture script" >&2
	exit 2
fi

find "$searched_folder" -type f ! -name .DS_Store -exec "$is_desktop_pic" {} $desktop_width $desktop_height $aspect_ratio_leeway \; $find_action
