# Generate locale for UTF-8 if needed
case "$HOST_OS" in
	"Darwin") ;; # Nothing to do for Darwin
	"Linux")
		readonly LOCALE_FILE="/etc/locale.gen"
		readonly SUM="$(shasum "$LOCALE_FILE")"
		sed -i '/en_US.UTF-8/s/^# //g' "$LOCALE_FILE"
		# We run locale-gen if the locale file has been modified
		test "$(shasum "$LOCALE_FILE")" = "$SUM" || locale-gen
	;;
	*)
		echo_warning "Unknown host OS: $HOST_OS" >/dev/stderr
		exit 1
	;;
esac
