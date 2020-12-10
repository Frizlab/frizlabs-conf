# Setup some macOS defaults

CURRENT_TASK_NAME="set key repeat"
catchout res  defaults_set_int NSGlobalDomain KeyRepeat 2
log_task_from_res "$res"

CURRENT_TASK_NAME="set initial key repeat"
catchout res  defaults_set_int NSGlobalDomain InitialKeyRepeat 15
log_task_from_res "$res"
