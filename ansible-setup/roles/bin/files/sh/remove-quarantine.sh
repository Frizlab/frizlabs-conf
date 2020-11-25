#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage: $0 dir_or_file" >/dev/stderr
	exit 42
fi

f="$1"

if [ ! -e "$f" ]; then
	echo "$0: $f: no such file or directory"
fi

if [ -d "$f" ]; then
	find "$f" -print0 | xargs -0 xattr -d com.apple.quarantine
fi

if [ -f "$f" ]; then
	xattr -d com.apple.quarantine "$f"
fi
