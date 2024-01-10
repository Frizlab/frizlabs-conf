# Install a user-owned Homebrew.

case "$HOST_OS:$HOST_ARCH" in
	Darwin:arm64)
		start_task "install user homebrew arm64"; catchout RES  libbrew__install_homebrew                         "$HOMEBREW_ARM64_USER_DIR"; log_task_from_res "$RES"
		# We do not really need x86 homebrew in theory, but let’s keep it just in case, because we can.
		start_task "install user homebrew x86";   catchout RES  libbrew__install_homebrew "--force-arch" "x86_64" "$HOMEBREW_X86_USER_DIR";   log_task_from_res "$RES"
	;;
	
	Linux:aarch64)
		start_task "install user homebrew arm64"; catchout RES  libbrew__install_homebrew "$HOMEBREW_ARM64_USER_DIR"; log_task_from_res "$RES"
		# A Rosetta-like stuff exists on Linux apparently, but it’s a bit complex to setup and we do not need it, so no x86 homebrew on arm Linux.
		# <https://ownyourbits.com/2018/06/13/transparently-running-binaries-from-any-architecture-in-linux-with-qemu-and-binfmt_misc/>
	;;
	
	Darwin:x86_64|Linux:x86_64)
		start_task "install user homebrew x86";   catchout RES  libbrew__install_homebrew "$HOMEBREW_X86_USER_DIR"; log_task_from_res "$RES"
	;;
	
	*)
		start_task "install user homebrew (unknown arch)"
		log_task_failure "cannot install user homebrew on unknown arch"
	;;
esac
