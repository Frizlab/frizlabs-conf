# Install base user packages (using user Homebrew)

for formula_name path_to_check in ${(kv)MAIN_USER_HOMEBREW_FORMULAE}; do
	CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "$HOMEBREW_NATIVE_USER_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
done

if test "$HOST_OS" = "Darwin"; then
	for cask_name path_to_check in ${(kv)MAIN_USER_HOMEBREW_CASKS}; do
		CURRENT_TASK_NAME="install cask $cask_name";   catchout res  install_brew_package "$HOMEBREW_NATIVE_USER_DIR" "$cask_name" "$path_to_check" "--cask";   log_task_from_res "$res"
	done
fi
