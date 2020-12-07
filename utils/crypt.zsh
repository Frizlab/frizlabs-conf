#!/bin/zsh -euopipefail
cd "$(dirname "$0")/.."


# We export PATH in case the variable is not exported yet
export PATH

# We add our own bins to the path, but agree to use the system or user-defined
# ones if they are already there
path+="$(pwd)/.cache/bin"

readonly CACHE_FOLDER="$(pwd)/.cache"
source "./src/lib/ccrypt.zsh"

case "${${0:t}:r}" in
	"decrypt") decrypt "$@";;
	"encrypt") encrypt "$@";;
	*)
		echo "You must call this script from the encrypt or decrypt scripts"
		exit 1
	;;
esac
