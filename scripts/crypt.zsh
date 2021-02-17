#!/bin/zsh -euopipefail
pushd "$(dirname "$0")/.."


# We export PATH in case the variable is not exported yet
export PATH

# We add our own bins to the path, but agree to use the system or user-defined
# ones if they are already there
path+="$(pwd)/.cache/bin"

readonly CACHE_FOLDER="$(pwd)/.cache"
source "./src/lib/ccrypt.zsh"

popd
case "${${0:t}:r}" in
	"decrypt_file") util_decrypt "$@";;
	"encrypt_file") util_encrypt "$@";;
	"decrypt_string") util_decrypt_string "$*";;
	"encrypt_string") printf "$*" | util_encrypt | base64;;
	*)
		echo "You must call this script from the encrypt_* or decrypt_* scripts"
		exit 1
	;;
esac
