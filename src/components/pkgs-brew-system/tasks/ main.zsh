# Install system packages (using system Homebrew)
source "./vars/ main.zsh"


for formula_name path_to_check in ${(kv)PKGS_BREW_SYSTEM__MAIN_FORMULAE}; do
	start_task "install formula $formula_name";   catchout RES  libbrew__install_brew_package "$HOMEBREW_SYSTEM_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$RES"
done

# We install the x86-only formulae in main Homebrew if not on Darwin arm64, otherwise we install a separate Homebrew dedicated for x86 installs.
if test "$HOST_OS:$HOST_ARCH" != "Darwin:arm64"; then
	for formula_name path_to_check in ${(kv)PKGS_BREW_SYSTEM__X86_FORMULAE}; do
		start_task "install formula $formula_name";   catchout RES  libbrew__install_brew_package                         "$HOMEBREW_SYSTEM_DIR"     "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$RES"
	done
else
	for formula_name path_to_check in ${(kv)PKGS_BREW_SYSTEM__X86_FORMULAE}; do
		start_task "install formula $formula_name";   catchout RES  libbrew__install_brew_package "--force-arch" "x86_64" "$HOMEBREW_X86_SYSTEM_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$RES"
	done
fi

# Install casks.
if test "$HOST_OS" = "Darwin"; then
	for cask_name path_to_check in ${(kv)PKGS_BREW_SYSTEM__CASKS}; do
		start_task "install cask $cask_name";   catchout RES  libbrew__install_brew_package "$HOMEBREW_SYSTEM_DIR" "$cask_name" "$path_to_check" "--cask";   log_task_from_res "$RES"
	done
fi
