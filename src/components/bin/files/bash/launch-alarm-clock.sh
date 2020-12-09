#!/bin/bash

if [ -z "$1" -o \( -n "$2" -a \( "$1" != "-c" -a "$1" != "--caffeinate" \) \) ]; then
	echo "Usage: $0 [-c|--caffeinate] hours_to_wait_before_music_launch" >&2
	echo "   If hours_to_wait_before_music_launch is not numeric, won't wait." >&2
	exit 1
fi

t="$1"
caffeinate=0
if [ -n "$2" ]; then
	t="$2"
	caffeinate=1
fi

if [ "$caffeinate" -ne 0 ]; then
	echo "Caffeinating sleep..."
	caffeinate &
fi
sleep $(echo "$t * 60 * 60" | bc)

start_itunes_vol=5
end_itunes_vol=85
vol_delay=2
vol_inc=1

echo "Starting alarm-clock"
osascript -e 'tell application "iTunes" to activate'
osascript -e 'tell application "iTunes" to set sound volume to '$start_itunes_vol
osascript -e 'tell application "System Events" to set volume 5'; # Max is 8, min is 0
osascript -e 'tell application "iTunes" to play user playlist "Alarm Clock"'

cur_vol=$start_itunes_vol
while [ $cur_vol -lt $end_itunes_vol ]; do
	sleep $vol_delay
	cur_vol=$((cur_vol + vol_inc))
	osascript -e 'tell application "iTunes" to set sound volume to '$cur_vol
done

if [ "$caffeinate" -ne 0 ]; then
	echo "Ending caffeination."
	kill %1
fi
