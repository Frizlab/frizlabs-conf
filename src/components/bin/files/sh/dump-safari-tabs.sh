#!/bin/sh
set -eu


# Usage: dump-safari-tabs [browser ...]
#
# Default browser is Safari.
#
# This script is compatible with:
#   - Safari
#   - Safari Technology Preview
#   - Orion
#   - Brave Browser
# It is _not_ compatible with:
#   - DuckDuckGo
#   - Firefox
#
# Tests were done on 2022-05-03


# osascript apparently logs to stderr, so we redirect stderr to stdout and
#  prefix stdout logs w/ “stdout: ” and stderr logs w/ “stderr: ”.
# This function redirect lines to the proper fd.
# Improperly prefixed lines are output to stderr.
function redirect_osascript_output() {
	while read line; do
		if echo "$line" | grep -Eq '^stdout: '; then echo "$line" | sed -E 's/^stdout: //';
		else                                         echo "$line" | sed -E 's/^stderr: //' >/dev/stderr; fi
	done
}


printf "DATE: "
date '+%d.%m.%Y-%H:%M:%S'
for browser in "${@:-Safari}"; do
	# Call AppleScript.
	osascript -e '
		-- Get the list of running processes
		tell application "System Events"
			set listOfRunningProcesses to (name of every process)
		end tell
		
		-- Check the selected browser is currently running
		if (listOfRunningProcesses contains "'"$browser"'") then
			log "stdout: BROWSER: '"$browser"'"
			tell application "'"$browser"'"
				repeat with theWindow in windows
					-- For the bounds definition: https://www.macosxautomation.com/applescript/firsttutorial/11.html
					set b to bounds of theWindow
					-- The distance in pixels from the left side of the screen to the left side of the window.
					set ll to (item 1 of b)
					-- The distance in pixels from the top of the screen to the top of the window.
					set tt to (item 2 of b)
					-- The distance in pixels from the left side of the screen to the right side of the window.
					set lr to (item 3 of b)
					-- The distance in pixels from the top of the screen to the bottom of the window.
					set tb to (item 4 of b)
					log "stdout: windowid - bounds: " & (index of theWindow as string) & " -" & ¬
						" ll=" & (ll as string) & ¬
						",tt=" & (tt as string) & ¬
						",lr=" & (lr as string) & ¬
						",tb=" & (tb as string)
					
					try
						repeat with theTab in tab of theWindow
							log "stdout: windowid - url: " & (index of theWindow as string) & " - " & (URL of theTab as string)
						end repeat
					on error errMsg
						log "stderr: error while iterating tab of window named " & (name of theWindow as string) & " in browser '"$browser"': " & errMsg
					end try
				end repeat
			end tell
		end if
	' 2>&1 | redirect_osascript_output
done
echo
