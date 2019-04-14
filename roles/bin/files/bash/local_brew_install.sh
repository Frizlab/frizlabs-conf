#!/bin/bash
set -euo pipefail

# ###################################### #
#  Install the given packages if needed  #
# ###################################### #


# TODO: Add a way to specify the Homebrew package name for a given package. E.g.
#       if you want to install realpath, you have to install coreutils.
#       A possible syntax would be
#          local_brew_install homebrew_path realpath,coreutils
#       Indeed if the package name is the same as the executable name, there
#       would be no need to specify both.
usage() {
	echo "usage: $0 homebrew_instance_folder package1 ..."
	echo ""
	echo "The script will check if all packages can be found in the path. If at"
	echo "least one package is not found, will try and install all the packages"
	echo "from a \"local\" homebrew install, which will be done in the given"
	echo "folder."
}

if [ "$#" -lt 2 ]; then
	usage >/dev/stderr
	exit 1
fi

readonly LOCAL_HOMEBREW_INSTALL="$1"
shift

export PATH="${PATH}:${LOCAL_HOMEBREW_INSTALL}/bin"
export BREW="${LOCAL_HOMEBREW_INSTALL}/bin/brew"

do_install=0
for p in "$@"; do
	if ! command -v "$p" >/dev/null; then
		do_install=1
		break
	fi
done
if [ "$do_install" != "0" ]; then
	if [ "$(uname)" != "Darwin" ]; then
		echo "Shyingly not trying Homebrew when not on macOS for now…" >/dev/stderr
		exit 2
	fi
	if [ ! -x "$BREW" ]; then
		mkdir -p "${LOCAL_HOMEBREW_INSTALL}"
		curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "${LOCAL_HOMEBREW_INSTALL}"
	fi
	if [ ! -x "$BREW" ]; then
		echo "There was an issue installing a local Homebrew instance!" >/dev/stderr
		exit 2
	fi
	
	export HOMEBREW_NO_ANALYTICS=1
	"$BREW" update
	"$BREW" install "$@"
fi
