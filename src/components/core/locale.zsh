# Generate locale for UTF-8 if needed
CURRENT_TASK_NAME="utf8-locale"

case "$HOST_OS" in
	"Darwin") ;; # Nothing to do for Darwin
	"Linux")
		log_task_start
		readonly TEMP_LOCALE="$(run_and_log_keep_stdout mktemp)"
		readonly LOCALE_FILE="/etc/locale.gen"
		run_and_log_keep_stdout "$SED" '/en_US.UTF-8/s/^# //g' -- "$LOCALE_FILE" >"$TEMP_LOCALE"
		# We run locale-gen if the locale file has been modified
		{ run_and_log "$DIFF" -- "$TEMP_LOCALE" "$LOCALE_FILE" && log_task_ok } || {
			# Note: Instead of tee we could simply move the temp file to the destination…
			{ run_and_log tee -- "$LOCALE_FILE" <"$TEMP_LOCALE" && run_and_log "$LOCALE_GEN" && log_task_change } ||
				log_task_failure "Cannot write to $LOCALE_FILE or locale-gen failed."
		}
		run_and_log "$RM" -f -- "$TEMP_LOCALE"
	;;
	*)
		log_task_start
		log_task_warning "Unknown host OS: $HOST_OS" >&2
	;;
esac
