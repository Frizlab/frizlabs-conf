#!/bin/sh

if [ -z "$1" -o -n "$2" ]; then
	echo "Usage: $0 base_dir" >/dev/stderr
	echo "   The program will find all empty dirs in base_dir and fill them with one empty file named .empty_dir." >/dev/stderr
	echo "   This is useful for source code management softwares like git that does not manage empty folders." >/dev/stderr
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "Error: argument must be a directory." >/dev/stderr
	exit 2
fi

find "$1" -type d | while read f; do
	if [ $(ls "$f" | wc -l) -eq 0 ]; then
		touch "$f/.empty_dir"
	fi
done
