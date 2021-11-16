#!/bin/sh
set -eu


# Let’s the user choose "Safari Technology Preview" instead of Safari
readonly BROWSER="${1:-Safari}"

# Call AppleScript
# osascript apparently logs to stderr, so we redirect stderr to stdout.
# If we assume osascript properly quit w/ a non-0 error code on error,
# we should save osascript’s output, then check $? and finally output the saved output to the proper fd… (TODO)
osascript -e '
-- Get the list of running processes
tell application "System Events"
	set listOfRunningProcesses to (name of every process)
end tell

-- Check the selected browser is currently running
if (listOfRunningProcesses contains "'"$BROWSER"'") then
	tell application "'"$BROWSER"'"
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
			log "windowid - bounds: " & (index of theWindow as string) & " -" & ¬
				" ll=" & (ll as string) & ¬
				",tt=" & (tt as string) & ¬
				",lr=" & (lr as string) & ¬
				",tb=" & (tb as string)
			
			repeat with theTab in tab of theWindow
				log "windowid - url: " & (index of theWindow as string) & " - " & (URL of theTab as string)
			end repeat
		end repeat
	end tell
end if
' 2>&1
