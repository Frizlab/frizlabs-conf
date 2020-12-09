#!/bin/sh

if [ -z "$1" -o -n "$2" ]; then
	echo "Usage: $0 base_dir" >&2
	echo "   The program will find all empty dirs in base_dir and fill them with one empty file named .empty_dir." >&2
	echo "   This is useful for source code management softwares like git that does not manage empty folders." >&2
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "Error: argument must be a directory." >&2
	exit 2
fi

find "$1" -type d | while read f; do
	if [ $(ls "$f" | wc -l) -eq 0 ]; then
		touch "$f/.empty_dir"
	fi
done
