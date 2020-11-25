#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 file" >/dev/stderr
	echo "   Returns 0 is jpeg is valid, something else otherwise"
	exit 42
fi

jpegtran "$1" >/dev/null 2>&1
