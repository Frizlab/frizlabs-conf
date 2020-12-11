# Install some package managers

source "./lib/homebrew.zsh"


# First a normal Homebrew install, in $HOMEBREW_DIR, w/ its formulae and casks.
CURRENT_TASK_NAME="install main homebrew"; catchout res  install_homebrew "$HOMEBREW_DIR"; log_task_from_res "$res"
for formula_name path_to_check in ${(kv)MAIN_HOMEBREW_FORMULAE}; do
	CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "$HOMEBREW_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
done
for cask_name path_to_check in ${(kv)MAIN_HOMEBREW_CASKS}; do
	CURRENT_TASK_NAME="install cask $cask_name";   catchout res  install_brew_package "$HOMEBREW_DIR" "$cask_name" "$path_to_check" "--cask";   log_task_from_res "$res"
done

# We install the x86-only formulae in main Homebrew if not on Darwin arm64,
# otherwise we install a separate Homebrew dedicated for x86 installs
if test "$HOST_OS:$HOST_ARCH" != "Darwin:arm64"; then
	for formula_name path_to_check in ${(kv)X86_HOMEBREW_FORMULAE}; do
		CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "$HOMEBREW_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
	done
else
	CURRENT_TASK_NAME="install homebrew x86"; catchout res  install_homebrew "$HOMEBREW_X86_DIR"; log_task_from_res "$res"
	for formula_name path_to_check in ${(kv)X86_HOMEBREW_FORMULAE}; do
		CURRENT_TASK_NAME="install formula $formula_name";   catchout res  install_brew_package "--force-x86" "$HOMEBREW_X86_DIR" "$formula_name" "$path_to_check" "--formula";   log_task_from_res "$res"
	done
fi


# Then a Homebrew installs for Python 3.*
CURRENT_TASK_NAME="install homebrew for python3.9";   catchout res  install_homebrew "$HOMEBREW_PYTHON39_DIR"; log_task_from_res "$res"
CURRENT_TASK_NAME="install python@3.9"; catchout res  install_brew_package "$HOMEBREW_PYTHON39_DIR" "python@3.9" "opt/python@3.9/bin/python3" "--formula"; log_task_from_res "$res"
# We do not install Python 3.8 and 3.7 because the compilation fails atm
#CURRENT_TASK_NAME="install homebrew for python3.8";   catchout res  install_homebrew "$HOMEBREW_PYTHON38_DIR"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install python@3.8"; catchout res  install_brew_package "$HOMEBREW_PYTHON38_DIR" "python@3.8" "opt/python@3.8/bin/python3" "--formula"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install homebrew for python3.7";   catchout res  install_homebrew "$HOMEBREW_PYTHON37_DIR"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install python@3.7"; catchout res  install_brew_package "$HOMEBREW_PYTHON37_DIR" "python@3.7" "opt/python@3.7/bin/python3" "--formula"; log_task_from_res "$res"


# We do not install Homebrew for Python 2.7 as it does not compile on Big Sur+
#CURRENT_TASK_NAME="install homebrew for python2.7";      catchout res  install_homebrew "$HOMEBREW_PYTHON2_DIR"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install python@2.7.17"; catchout res  install_brew_package "$HOMEBREW_PYTHON2_DIR" "Frizlab/Perso/python@2.7.17" "opt/python@2.7.17/bin/python2" "--formula"; log_task_from_res "$res"
