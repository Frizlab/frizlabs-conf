# Generate locale for UTF-8 if needed
case "$HOST_OS" in
	"Darwin") ;; # Nothing to do for Darwin
	"Linux")
		readonly TEMP_LOCALE="$(mktemp)"
		readonly LOCALE_FILE="/etc/locale.gen"
		sed '/en_US.UTF-8/s/^# //g' "$LOCALE_FILE" >"$TEMP_LOCALE"
		# We run locale-gen if the locale file has been modified
		diff "$TEMP_LOCALE" "$LOCALE_FILE" >/dev/null 2>&1 || {
			cat "$TEMP_LOCALE" >"$LOCALE_FILE"
			locale-gen
		}
		rm -f "$TEMP_LOCALE"
	;;
	*)
		echo_warning "Unknown host OS: $HOST_OS" >/dev/stderr
		exit 1
	;;
esac
