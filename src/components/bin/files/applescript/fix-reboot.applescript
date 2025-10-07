#!/usr/bin/osascript

on RelaunchApps(appNames)
	-- Find the apps that are launched in the list we’re given.
	set launchedApps to {}
	repeat with appName in appNames
		if application appName is running then
			set end of launchedApps to (application appName)
		end if
	end repeat
	
	-- Now we quit all of the apps that are launched,
	--  then wait a bit for the dust to settle,
	--  and finally relaunch all of the apps (without activation).
	repeat with launchedApp in launchedApps
		tell launchedApp to quit
	end repeat
	delay 1.5
	repeat with appToLaunch in launchedApps
		tell appToLaunch to launch
	end repeat
end RelaunchApps


RelaunchApps({    ¬
	"Podcasts",    ¬
	"Freeform",    ¬
	"Reminders",   ¬
	"Notes",       ¬
	"NetNewsWire", ¬
	"Messages"     ¬
})
