#!/bin/bash
set -euo pipefail

all_processes=", $(osascript -e 'tell application "System Events" to name of every process'),"
case "$all_processes" in
	*", Xcode,"*)
		# Xcode is launched; let’s ask whether to quit it.
		read -p "Xcode is launched. Quit it? " -n 2 f
		while [ "$f" != "" -a $(echo "$f" | wc -c) -gt 2 ]; do read -n 2 f; done
		if [ "$f" != "y" ]; then exit 1; fi
		osascript -e 'tell application "Xcode" to quit'
		;;
esac
