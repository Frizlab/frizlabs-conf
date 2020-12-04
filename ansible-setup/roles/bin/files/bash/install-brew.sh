#!/bin/bash
set -euo pipefail

# ################################## #
#  Install brew in the given folder  #
# ################################## #


usage() {
	echo "usage: $0 destination"
	echo ""
	echo "The script will download brew at the given path."
	echo "brew will be available at “destination/bin/brew”."
}

if [ "$#" -ne 1 ]; then
	usage >/dev/stderr
	exit 1
fi

readonly LOCAL_HOMEBREW_INSTALL="$1"
readonly BREW="${LOCAL_HOMEBREW_INSTALL}/bin/brew"

if [ ! -x "$BREW" ]; then
	if [ -e "$LOCAL_HOMEBREW_INSTALL" ]; then
		echo "brew binary does not exist at path '$BREW', but '$LOCAL_HOMEBREW_INSTALL' exists." >/dev/stderr
		exit 3
	fi
	mkdir -p "$LOCAL_HOMEBREW_INSTALL"
	curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "${LOCAL_HOMEBREW_INSTALL}"
	HOMEBREW_NO_ANALYTICS=1 "$BREW" update
fi
if [ ! -x "$BREW" ]; then
	echo "There was an issue installing a local Homebrew instance!" >/dev/stderr
	exit 2
fi
