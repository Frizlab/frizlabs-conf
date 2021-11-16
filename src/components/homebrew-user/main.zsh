# Install a user-owned Homebrew.

# For now we only check for Darwin ARM64.
if test "$HOST_OS:$HOST_ARCH" != "Darwin:arm64"; then
	start_task "install user homebrew x86";   catchout RES  install_homebrew                         "$HOMEBREW_X86_USER_DIR";   log_task_from_res "$RES"
else
	start_task "install user homebrew arm64"; catchout RES  install_homebrew                         "$HOMEBREW_ARM64_USER_DIR"; log_task_from_res "$RES"
	start_task "install user homebrew x86";   catchout RES  install_homebrew "--force-arch" "x86_64" "$HOMEBREW_X86_USER_DIR";   log_task_from_res "$RES"
fi
