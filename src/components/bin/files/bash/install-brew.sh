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

if [ "$#" -ne 1 -o "$1" = "-h" -o "$1" = "--help" -o "$1" = "help" ]; then
	usage >&2
	exit 1
fi

readonly LOCAL_HOMEBREW_INSTALL="$1"
readonly BREW="${LOCAL_HOMEBREW_INSTALL}/bin/brew"

if [ ! -x "$BREW" ]; then
	# I kinda like this check, because it makes sure parent folders are consciously created w/ correct perms before installing brew.
	# However it is annoying in some cases, so we disable it, at least for now.
#	if [ ! -d "$(dirname -- "$LOCAL_HOMEBREW_INSTALL")" ]; then
#		echo "Asked to install brew at path '$LOCAL_HOMEBREW_INSTALL' but parent folder does not exist." >&2
#		exit 4
#	fi
	if [ -e "$LOCAL_HOMEBREW_INSTALL" -a "$(ls -- "$LOCAL_HOMEBREW_INSTALL" | wc -l)" -gt 0 ]; then
		echo "brew binary does not exist at path '$BREW', but '$LOCAL_HOMEBREW_INSTALL' exists." >&2
		exit 3
	fi
	mkdir -p -- "$LOCAL_HOMEBREW_INSTALL"
	curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "${LOCAL_HOMEBREW_INSTALL}"
	HOMEBREW_NO_ANALYTICS=1 "$BREW" update
fi
if [ ! -x "$BREW" ]; then
	echo "There was an issue installing a local Homebrew instance!" >&2
	exit 2
fi
