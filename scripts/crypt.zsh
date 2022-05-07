#!/bin/zsh -euopipefail
pushd "$(dirname "$0")/.."


# We export PATH in case the variable is not exported yet.
export PATH

# We add our own bins to the path, but agree to use the system or user-defined ones if they are already there.
path+="$(pwd)/.cache/bin"

readonly CACHE_FOLDER="$(pwd)/.cache"
source "./src/lib/vars-facts.zsh"
source "./src/lib/vars-executables.zsh"
source "./src/lib/lib-ccrypt.zsh"

popd
case "${${0:t}:r}" in
	"decrypt_file") decrypt "$@";;
	"encrypt_file") encrypt "$@";;
	"decrypt_string") decrypt_string "$*";;
	"encrypt_string") printf "$*" | encrypt | base64;;
	*)
		echo "You must call this script from the encrypt_* or decrypt_* scripts"
		exit 1
	;;
esac
