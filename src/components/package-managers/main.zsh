# Install some package managers

source "./lib/homebrew.zsh"

# First a “normal” Homebrew install, in $HOMEBREW_DIR
CURRENT_TASK_NAME="main homebrew"
catchout res  install_homebrew "$HOMEBREW_DIR"
log_task_from_res "$res"

# Then a Homebrew install for Python 3.9
CURRENT_TASK_NAME="python3 homebrew";   catchout res  install_homebrew "$HOMEBREW_DIR";                                                        log_task_from_res "$res"
CURRENT_TASK_NAME="install python@3";   catchout res  install_brew_package "$HOMEBREW_PYTHON3_DIR" "python@3"    "opt/python@3/bin/python3";   log_task_from_res "$res"
CURRENT_TASK_NAME="install python@3.9"; catchout res  install_brew_package "$HOMEBREW_PYTHON3_DIR" "python@3.9"  "opt/python@3.9/bin/python3"; log_task_from_res "$res"
CURRENT_TASK_NAME="install python@3.8"; catchout res  install_brew_package "$HOMEBREW_PYTHON3_DIR" "python@3.8"  "opt/python@3.8/bin/python3"; log_task_from_res "$res"
CURRENT_TASK_NAME="install python@3.7"; catchout res  install_brew_package "$HOMEBREW_PYTHON3_DIR" "python@3.7"  "opt/python@3.7/bin/python3"; log_task_from_res "$res"

# And finally a Homebrew install for Python 2!
#CURRENT_TASK_NAME="python2 homebrew"
#catchout res  install_homebrew "$HOMEBREW_PYTHON2_DIR"
#log_task_from_res "$res"
