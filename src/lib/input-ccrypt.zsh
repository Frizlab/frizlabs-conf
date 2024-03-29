### Needs: CACHE_FOLDER var.
### Gives: CCRYPT_KEY1_PATH, CCRYPT_KEY2_PATH and CCRYPT_KEY3_PATH vars.

# Install ccrypt if needed
{ command -v ccencrypt >/dev/null 2>&1 && command -v ccdecrypt >/dev/null 2>&1 } || {
	echo "*** Downloading and compiling ccrypt in the .cache folder..."
	pushd "$CACHE_FOLDER"
	readonly CCRYPT_SHASUM="6d20a4db9ef7caeea6ce432f3cffadf10172e420"
	readonly CCRYPT_VERSION="1.11"
	readonly CCRYPT_BASENAME="ccrypt-$CCRYPT_VERSION"
	readonly CCRYPT_TAR_NAME="$CCRYPT_BASENAME.tar.gz"
	readonly CCRYPT_URL="https://ccrypt.sourceforge.net/download/$CCRYPT_VERSION/$CCRYPT_TAR_NAME"
	test -e "$CCRYPT_TAR_NAME" || curl --location "$CCRYPT_URL" >"$CCRYPT_TAR_NAME"
	test "$(shasum "$CCRYPT_TAR_NAME" | cut -d' ' -f1)" = "$CCRYPT_SHASUM" || {
		echo "***** ERROR: ccrypt sha does not match expected sha. Bailing out."
		exit 1
	}
	"$TAR" xf "$CCRYPT_TAR_NAME"
	pushd "$CCRYPT_BASENAME"
	./configure --prefix "$CACHE_FOLDER"
	make install
	popd
	"$RM" -fr "$CCRYPT_BASENAME"
	popd
}


readonly CCRYPT_KEY1_PATH="$CACHE_FOLDER/.pass1"
readonly CCRYPT_KEY2_PATH="$CACHE_FOLDER/.pass2"
readonly CCRYPT_KEY3_PATH="$CACHE_FOLDER/.pass3"


test -f "$CCRYPT_KEY1_PATH" || { read -rs 'pass?Please enter pass 1: '; echo; echo -n "$pass" >"$CCRYPT_KEY1_PATH" }
test -f "$CCRYPT_KEY2_PATH" || { read -rs 'pass?Please enter pass 2: '; echo; echo -n "$pass" >"$CCRYPT_KEY2_PATH" }
test -f "$CCRYPT_KEY3_PATH" || { read -rs 'pass?Please enter pass 3: '; echo; echo -n "$pass" >"$CCRYPT_KEY3_PATH" }
