# Install base user packages (using user Homebrew)

for formula_name path_to_check in ${(kv)MAIN_SYSTEM_HOMEBREW_FORMULAE}; do
	CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "$HOMEBREW_SYSTEM_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
done

# We install the x86-only formulae in main Homebrew if not on Darwin arm64,
# otherwise we install a separate Homebrew dedicated for x86 installs
if test "$HOST_OS:$HOST_ARCH" != "Darwin:arm64"; then
	for formula_name path_to_check in ${(kv)X86_SYSTEM_HOMEBREW_FORMULAE}; do
		CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package                         "$HOMEBREW_SYSTEM_DIR"     "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
	done
else
	for formula_name path_to_check in ${(kv)X86_SYSTEM_HOMEBREW_FORMULAE}; do
		CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "--force-arch" "x86_64" "$HOMEBREW_X86_SYSTEM_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
	done
fi
