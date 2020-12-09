#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 file" >&2
	echo "   Returns 0 is jpeg is valid, something else otherwise" >&2
	exit 42
fi

jpegtran "$1" >/dev/null 2>&1
