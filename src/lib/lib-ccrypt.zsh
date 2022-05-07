function libccrypt__decrypt() {
	ccdecrypt --suffix "" --keyfile "$CCRYPT_KEY3_PATH" "$@" >/dev/null 2>/dev/null || { return 1 }
	ccdecrypt --suffix "" --keyfile "$CCRYPT_KEY2_PATH" "$@" >/dev/null 2>/dev/null || { return 1 }
	ccdecrypt             --keyfile "$CCRYPT_KEY1_PATH" "$@" >/dev/null 2>/dev/null || { return 1 }
	return 0
}

function libccrypt__decrypt_string() {
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



## Should NOT be used in the install script; meant to be used by an util script.
function encrypt() {
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
function decrypt() {
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
function decrypt_string() {
	tr -d '\r\n\t ' <<<"$*" | base64 -d | decrypt
}
