# Install base user packages (using user Homebrew).

for formula_name path_to_check in ${(kv)MAIN_USER_HOMEBREW_FORMULAE}; do
	start_task "install formula $formula_name";   catchout RES  libbrew__install_brew_package "$HOMEBREW_USER_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$RES"
done

if test "$HOST_OS" = "Darwin"; then
	for cask_name path_to_check in ${(kv)MAIN_USER_HOMEBREW_CASKS}; do
		start_task "install cask $cask_name";   catchout RES  libbrew__install_brew_package "$HOMEBREW_USER_DIR" "$cask_name" "$path_to_check" "--cask";   log_task_from_res "$RES"
	done
fi
