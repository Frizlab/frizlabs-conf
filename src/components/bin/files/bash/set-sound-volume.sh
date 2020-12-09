#!/bin/bash
set -euo pipefail

# ############################################### #
#  Set system sound volume on macOS w/ osascript  #
# ############################################### #


function usage() {
	echo "usage: $0 new_volume" >&2
	echo "   new_volume must be an integer between 0 and 100" >&2
	exit 1
}

arg="${1:-}"
case "$arg" in ''|*[!0-9]*) usage;; esac; # From https://stackoverflow.com/a/3951175 let’s check the arg is an int
if [ "$arg" -gt 100 ]; then usage; fi; # If int >100, we show usage (all other cases including negative numbers are handled on line above)

new_volume="$(echo "($arg * 8) / 100" | bc)"
osascript -e "tell application \"System Events\" to set volume $new_volume"; # Max is 8, min is 0
