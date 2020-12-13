# Install a user-owned Homebrew

case "$HOST_OS:$HOST_ARCH" in
	"Darwin:arm64")
		CURRENT_TASK_NAME="install user homebrew arm64"; catchout res  install_homebrew                         "$HOMEBREW_ARM64_USER_DIR"; log_task_from_res "$res"
		CURRENT_TASK_NAME="install user homebrew x86";   catchout res  install_homebrew "--force-arch" "x86_64" "$HOMEBREW_X86_USER_DIR";   log_task_from_res "$res"
		CURRENT_TASK_NAME="link native homebrew";        catchout res  lnk "$HOMEBREW_ARM64_USER_DIR" "$HOMEBREW_NATIVE_USER_DIR" 755;      log_task_from_res "$res"
	;;
	
	Darwin:x86_64|Linux:*)
		CURRENT_TASK_NAME="install user homebrew x86";   catchout res  install_homebrew "$HOMEBREW_X86_USER_DIR";                    log_task_from_res "$res"
		CURRENT_TASK_NAME="link native homebrew";        catchout res  lnk "$HOMEBREW_X86_USER_DIR" "$HOMEBREW_NATIVE_USER_DIR" 755; log_task_from_res "$res"
	;;
	
	*)
		CURRENT_TASK_NAME="install user homebrew (unknown arch)";   catchout res  install_homebrew "$HOMEBREW_NATIVE_USER_DIR";      log_task_from_res "$res"
	;;
esac
