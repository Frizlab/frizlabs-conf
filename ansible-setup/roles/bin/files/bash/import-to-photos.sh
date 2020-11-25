#!/bin/bash

echo "This script should work, but is not tested... Please debug before using." >/dev/stderr
exit 42

usage() {
	echo "Usage: $0 [-f] dir" >/dev/stderr
	exit 42
}

if [ $# -ne 1 -a $# -ne 2 ]; then usage; fi

force=0
if [ $# -eq 2 ]; then
	if [ "$1" != "-f" ]; then usage; fi
	force=1
	shift
fi

osa="$(dirname "$(type -p "$(basename "$0")")")/import_to_photos.scpt"
fii="$(dirname "$(type -p "$(basename "$0")")")/find_invalid_images.sh"

if [ ! -f "$osa" ]; then echo "Cannot find applescript to import photos. Exiting." >/dev/stderr; exit 21; fi
if [ ! -x "$fii" ]; then echo "Cannot find script to detect invalid images. Exiting." >/dev/stderr; exit 21; fi

function warn_to_continue() {
	read -p "${1}Is it ok? (y for yes, anything else for no) " -n 2 f
	while [ "$f" != "" -a $(echo "$f" | wc -c) -gt 2 ]; do read -n 2 f; done
	if [ "$f" = "y" ]; then return 0; else return 1; fi
}

nf=0
nph=0
cd "$1" || exit 21
for d in *; do
	if [ ! -d "$d" ]; then continue; fi

	test -f "$d"/.DS_Store && rm -f "$d"/.DS_Store

	/bin/bash "$fii" "$d" 0 | xargs -0 trash -v

	count=$(find "$d" -type f | wc -l | sed -E 's/[^0-9]//g')
	if [ $count -eq 0 ]; then continue; fi

	nf=$((nf+1))
	nph=$((nph+count))

	find "$(pwd)/$d" -type f -print0 | xargs -0 osascript "$osa" "$d"
	should_delete=1
	if [ $force -eq 0 ]; then
		warn_to_continue "$count photo(s) should have been imported in \"$d\". " || should_delete=0
	else
		sleeptime=$((count / 2))
		if [ $sleeptime -lt 3 ]; then sleeptime=3; fi
		if [ $sleeptime -gt 90 ]; then sleeptime=90; fi
		echo "$count photo(s) should have been imported in \"$d\". Assuming ok, sleeping $sleeptime second(s)."
		sleep $sleeptime
	fi
	if [ $should_delete -ne 1 ]; then
		echo "Did NOT delete files in \"$d\"" >/dev/stderr
	else
		find "$d" -type f -print0 | xargs -0 trash
	fi
done

echo "Summary:"
echo "   Number of folder treated: $nf"
echo "   Number of total photo treated: $nph"
