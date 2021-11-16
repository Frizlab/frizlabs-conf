# Generate locale for UTF-8 if needed
CURRENT_TASK_NAME="utf8-locale"

case "$HOST_OS" in
	"Darwin") ;; # Nothing to do for Darwin
	"Linux")
		log_task_start
		readonly TEMP_LOCALE="$(mktemp)"
		readonly LOCALE_FILE="/etc/locale.gen"
		"$SED" '/en_US.UTF-8/s/^# //g' -- "$LOCALE_FILE" >"$TEMP_LOCALE"
		# We run locale-gen if the locale file has been modified
		{ "$DIFF" -- "$TEMP_LOCALE" "$LOCALE_FILE" >/dev/null 2>&1 && log_task_ok } || {
			{ "$CAT" -- "$TEMP_LOCALE" >"$LOCALE_FILE" && locale-gen >/dev/null 2>&1 && log_task_change } ||
				log_task_failure "Cannot write to $LOCALE_FILE. Do you have the permissions to do it?"
		}
		"$RM" -f -- "$TEMP_LOCALE"
	;;
	*)
		log_task_start
		log_task_warning "Unknown host OS: $HOST_OS" >&2
	;;
esac
