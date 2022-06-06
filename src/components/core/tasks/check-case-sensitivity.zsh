# Check whether the file-system is case-sensitive

start_task "check whether the file-system is case-sensitive"
[ -e "/tmp" ] && {
	[ -e "/Tmp" -a -e "/tMp" -a -e "/tmP" ] && \
		log_task_warning "/tmp, /Tmp, /tMp and /tmP exist, we’re probably case-insensitive." || \
		log_task_ok
} || log_task_failure "/tmp does not exist, cannot check for case-sensitivity"
