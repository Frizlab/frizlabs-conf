#!/bin/sh
if [ ! "$1" -o ! "$2" ] ; then
	echo "Usage : $0 inFile outFile"
	exit 1
fi
sed "s:^\(/F4\.1[^/].*sf\)$:\1 /s {pop} bind def:" < $1 > $2
