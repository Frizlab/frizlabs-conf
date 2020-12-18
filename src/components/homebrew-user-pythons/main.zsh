# Install Homebrew instances for Python
# Do not forget to brew python in brew-all in .shrc:dyn when this is modified.

# Python 3.9
CURRENT_TASK_NAME="install homebrew for python3.9";   catchout res  install_homebrew "$HOMEBREW_PYTHON39_USER_DIR"; log_task_from_res "$res"
CURRENT_TASK_NAME="install python@3.9"; catchout res  install_brew_package "$HOMEBREW_PYTHON39_USER_DIR" "python@3.9" "opt/python@3.9/bin/python3" "--formula"; log_task_from_res "$res"
# We do not install Python 3.8 and 3.7 because the compilation fails atm
#CURRENT_TASK_NAME="install homebrew for python3.8";   catchout res  install_homebrew "$HOMEBREW_PYTHON38_USER_DIR"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install python@3.8"; catchout res  install_brew_package "$HOMEBREW_PYTHON38_USER_DIR" "python@3.8" "opt/python@3.8/bin/python3" "--formula"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install homebrew for python3.7";   catchout res  install_homebrew "$HOMEBREW_PYTHON37_USER_DIR"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install python@3.7"; catchout res  install_brew_package "$HOMEBREW_PYTHON37_USER_DIR" "python@3.7" "opt/python@3.7/bin/python3" "--formula"; log_task_from_res "$res"


# We do not install Homebrew for Python 2.7 as it does not compile on Big Sur+
#CURRENT_TASK_NAME="install homebrew for python2.7";      catchout res  install_homebrew "$HOMEBREW_PYTHON27_USER_DIR"; log_task_from_res "$res"
#CURRENT_TASK_NAME="install python@2.7.17"; catchout res  install_brew_package "$HOMEBREW_PYTHON27_USER_DIR" "Frizlab/Perso/python@2.7.17" "opt/python@2.7.17/bin/python2" "--formula"; log_task_from_res "$res"
