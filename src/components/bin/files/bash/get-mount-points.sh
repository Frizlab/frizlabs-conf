#!/bin/bash
set -euo pipefail


if [ -z "$1" ]; then
	echo "Usage: $0 image_disk" >&2
	exit 42
fi


if [ ! -e "$1" ]; then
	echo "$0: $1: No such file or directory" >&2
	exit 21
fi

di="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
hdiutil info | awk '
	BEGIN {
		FS=": ";
	}
	
	/================================================/ {
		cur_image_path = "";
		FS=": ";
	}
	
	/image-path/ {
		image_path = $2;
		FS="\t";
	}
	
	/^\/dev\/.*/ {
		if (image_path == "'"$di"'") {
			if ($3 != "") print $3;
		}
	}
'
