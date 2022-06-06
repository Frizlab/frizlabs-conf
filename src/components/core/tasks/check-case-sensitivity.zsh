# Check whether the file-system is case-sensitive

start_task "check whether the file-system is case-sensitive"
# ⚠️ Do NOT check /tmp! On macOS, /tmp folder is ALWAYS case-insensitive (like the rest of the system).
[ -e "$ROOT_FOLDER/src" ] && {
	[ -e "$ROOT_FOLDER/sRc" ] && \
		log_task_warning "An sRc file at the root of the repo was found; we’re probably case-insensitive." || \
		log_task_ok
} || log_task_failure "The src folder does not exist, this is not normal."
