# Install an admin-owned Homebrew.

case "$HOST_OS:$HOST_ARCH" in
	"Darwin:arm64")
		start_task "install system homebrew arm64"; catchout RES  install_homebrew                         "$HOMEBREW_ARM64_SYSTEM_DIR"; log_task_from_res "$RES"
		# We should not need x86 brew on M1 anymore, so skip its install.
#		start_task "install system homebrew x86";   catchout RES  install_homebrew "--force-arch" "x86_64" "$HOMEBREW_X86_SYSTEM_DIR";   log_task_from_res "$RES"
	;;
	
	Darwin:x86_64|Linux:*)
		start_task "install system homebrew x86";   catchout RES  install_homebrew "$HOMEBREW_X86_SYSTEM_DIR"; log_task_from_res "$RES"
	;;
	
	*)
		start_task "install system homebrew (unknown arch)"
		log_task_failure "cannot install system homebrew on unknown arch"
	;;
esac
