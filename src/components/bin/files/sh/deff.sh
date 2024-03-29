#!/bin/sh
set -eu


# Usage: deff bundle.id
# First run will always show an empty diff (the initial state will be saved in the Caches directory).
# Next run, if the defaults have been changed, the diff will be shown.

readonly BUNDLE_ID="${1:-}"


readonly CACHES_FOLDER="$HOME/Library/Caches/me.frizlab.deff"
mkdir -p "$CACHES_FOLDER"


readonly BEFORE_PATH="$CACHES_FOLDER/$BUNDLE_ID-before.txt"
readonly  AFTER_PATH="$CACHES_FOLDER/$BUNDLE_ID-after.txt"

# Is it the first run for this bundle id?
if test ! -e "$AFTER_PATH"; then
	# First run, we simply store the current state.
	#
	# Note:
	# NO quotes around the BUNDLE_ID variable as we do want to list all the defaults if an empty bundle ID is given.
	# We assume all valid bundle IDs will never need quoting.
	# We do this because we want to avoid an if haha.
	defaults read $BUNDLE_ID >"$AFTER_PATH"
else
	# Not first run, we get the new state and diff.
	mv -f -- "$AFTER_PATH" "$BEFORE_PATH"
	defaults read $BUNDLE_ID >"$AFTER_PATH"
	diff -- "$BEFORE_PATH" "$AFTER_PATH"
fi
