#!/bin/zsh -euopipefail


################################
# Paths Setup and Verification #
################################

test "$(basename "$0")" = "install" || {
	echo "This script must be run from the install alias." >/dev/stderr
	exit 1
}
cd "$(dirname "$0")"

# We export PATH in case the variable is not exported yet
export PATH

# We add our own bins to the path, but agree to use the system or user-defined
# ones if they are already there
path+="$(pwd)/.cache/bin"

# Let’s define the different paths we will need
readonly CACHE_FOLDER="$(pwd)/.cache"
readonly SRC_FOLDER="$(pwd)/src"
readonly LIB_FOLDER="$SRC_FOLDER/lib"
readonly COMPONENTS_FOLDER="$SRC_FOLDER/components"

# Create the cache folder if needed
mkdir -p "$CACHE_FOLDER" && chmod 700 "$CACHE_FOLDER"


###############
# Import libs #
###############

source "$LIB_FOLDER/logger.zsh"
source "$LIB_FOLDER/ccrypt.zsh"


# Install ccrypt if needed
command -v ccdecrypt >/dev/null 2>&1 || {
	echo "*** Downloading and compiling ccrypt in the .cache folder..."
	pushd .cache
	readonly CCRYPT_SHASUM="6d20a4db9ef7caeea6ce432f3cffadf10172e420"
	readonly CCRYPT_VERSION="1.11"
	readonly CCRYPT_BASENAME="ccrypt-$CCRYPT_VERSION"
	readonly CCRYPT_TAR_NAME="$CCRYPT_BASENAME.tar.gz"
	readonly CCRYPT_URL="http://ccrypt.sourceforge.net/download/$CCRYPT_VERSION/$CCRYPT_TAR_NAME"
	test -e "$CCRYPT_TAR_NAME" || curl "$CCRYPT_URL" >"$CCRYPT_TAR_NAME"
	test "$(shasum "$CCRYPT_TAR_NAME" | cut -d' ' -f1)" = "$CCRYPT_SHASUM" || {
		echo "***** ERROR: ccrypt sha does not match expected sha. Bailing out."
		exit 1
	}
	tar xf "$CCRYPT_TAR_NAME"
	pushd "$CCRYPT_BASENAME"
	./configure --prefix "$(pwd)/.."
	make install
	popd
	rm -fr "$CCRYPT_BASENAME"
	popd
}
