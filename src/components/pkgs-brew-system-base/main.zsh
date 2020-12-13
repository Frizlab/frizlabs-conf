# Install base user packages (using user Homebrew)

for formula_name path_to_check in ${(kv)MAIN_SYSTEM_HOMEBREW_FORMULAE}; do
	CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "$HOMEBREW_SYSTEM_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
done
