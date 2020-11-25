#!/bin/bash


if [ $# -ne 1 ]; then
	echo "Usage: $0 file" >&2
	exit 42
fi

d=$(mktemp -d -t "markdown") || exit 1
f="$d/markdown.html"
markdown "$1" >"$f" && open "$f"
sleep 1 && rm -fr "$d"
