#!/bin/bash
set -euo pipefail

# ############################################### #
#  Set system sound volume on macOS w/ osascript  #
# ############################################### #


if [ "$1" = "--help" ] || [ "$1" = "help" ] || [ -z "$1" ] || [ "$1" -lt 0 ] || [ "$1" -gt 100 ]; then
	echo "Usage: $0 new_volume" >/dev/stderr
	echo "   new_volume must be between 0 and 100" >/dev/stderr
	exit 1
fi

new_volume="$(echo "($1 * 8) / 100" | bc)"
osascript -e "tell application \"System Events\" to set volume $new_volume"; # Max is 8, min is 0
