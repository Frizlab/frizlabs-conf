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

#
## First a normal Homebrew install, in $HOMEBREW_DIR, w/ its formulae and casks.
#CURRENT_TASK_NAME="install main homebrew"; catchout res  install_homebrew "$HOMEBREW_DIR"; log_task_from_res "$res"
#
## We install the x86-only formulae in main Homebrew if not on Darwin arm64,
## otherwise we install a separate Homebrew dedicated for x86 installs
#if test "$HOST_OS:$HOST_ARCH" != "Darwin:arm64"; then
#	for formula_name path_to_check in ${(kv)X86_HOMEBREW_FORMULAE}; do
#		CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "$HOMEBREW_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
#	done
#else
#	CURRENT_TASK_NAME="install homebrew x86"; catchout res  install_homebrew "$HOMEBREW_X86_DIR"; log_task_from_res "$res"
#	for formula_name path_to_check in ${(kv)X86_HOMEBREW_FORMULAE}; do
#		CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "--force-arch" "x86_64" "$HOMEBREW_X86_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
#	done
#fi
