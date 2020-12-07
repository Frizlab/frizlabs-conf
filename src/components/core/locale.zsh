# Generate locale for UTF-8 if needed
case "$HOST_OS" in
	"Darwin") ;; # Nothing to do for Darwin
	"Linux")
		readonly TEMP_LOCALE="$(mktemp)"
		readonly LOCALE_FILE="/etc/locale.gen"
		sed '/en_US.UTF-8/s/^# //g' "$LOCALE_FILE" >"$TEMP_LOCALE"
		# We run locale-gen if the locale file has been modified
		test "$(shasum "$TEMP_LOCALE" | cut -d' ' -f1)" = "$(shasum "$LOCALE_FILE" | cut -d' ' -f1)" || {
			cat "$TEMP_LOCALE" >"$LOCALE_FILE"
			locale-gen
		}
	;;
	*)
		echo_warning "Unknown host OS: $HOST_OS" >/dev/stderr
		exit 1
	;;
esac
