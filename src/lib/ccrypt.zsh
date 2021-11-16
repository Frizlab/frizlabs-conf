# Install ccrypt if needed
{ command -v ccencrypt >/dev/null 2>&1 && command -v ccdecrypt >/dev/null 2>&1 } || {
	echo "*** Downloading and compiling ccrypt in the .cache folder..."
	pushd "$CACHE_FOLDER"
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


## Should NOT be used in the install script; meant to be used by an util script.
function util_encrypt() {
	if test $# -gt 0; then {
		ccencrypt --suffix "" --keyfile "$CCRYPT_KEY1_PATH" "$@"
		ccencrypt --suffix "" --keyfile "$CCRYPT_KEY2_PATH" "$@"
		ccencrypt             --keyfile "$CCRYPT_KEY3_PATH" "$@"
	} else {
		ccencrypt --keyfile "$CCRYPT_KEY1_PATH" | \
		ccencrypt --keyfile "$CCRYPT_KEY2_PATH" | \
		ccencrypt --keyfile "$CCRYPT_KEY3_PATH"
	} fi
}

## Should NOT be used in the install script; meant to be used by an util script.
function util_decrypt() {
	if test $# -gt 0; then {
		ccdecrypt --suffix "" --keyfile "$CCRYPT_KEY3_PATH" "$@"
		ccdecrypt --suffix "" --keyfile "$CCRYPT_KEY2_PATH" "$@"
		ccdecrypt             --keyfile "$CCRYPT_KEY1_PATH" "$@"
	} else {
		ccdecrypt --keyfile "$CCRYPT_KEY3_PATH" | \
		ccdecrypt --keyfile "$CCRYPT_KEY2_PATH" | \
		ccdecrypt --keyfile "$CCRYPT_KEY1_PATH"
	} fi
}

## Should NOT be used in the install script; meant to be used by an util script.
function util_decrypt_string() {
	tr -d '\r\n\t ' <<<"$*" | base64 -d | decrypt
}

function decrypt() {
	ccdecrypt --suffix "" --keyfile "$CCRYPT_KEY3_PATH" "$@" >/dev/null 2>/dev/null || { return 1 }
	ccdecrypt --suffix "" --keyfile "$CCRYPT_KEY2_PATH" "$@" >/dev/null 2>/dev/null || { return 1 }
	ccdecrypt             --keyfile "$CCRYPT_KEY1_PATH" "$@" >/dev/null 2>/dev/null || { return 1 }
	return 0
}

function decrypt_string() {
	tr -d '\r\n\t ' <<<"$*" | base64 -d 2>/dev/null |        \
		ccdecrypt --keyfile "$CCRYPT_KEY3_PATH" 2>/dev/null | \
		ccdecrypt --keyfile "$CCRYPT_KEY2_PATH" 2>/dev/null | \
		ccdecrypt --keyfile "$CCRYPT_KEY1_PATH" 2>/dev/null   \
	|| {
		log_task_start
		log_task_warning "Cannot decrypt string. Returning string “<FRZ_DECRYPTION_FAILED>”."
		echo "<FRZ_DECRYPTION_FAILED>"
	}
}
