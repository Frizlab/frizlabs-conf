# Setup some macOS defaults

CURRENT_TASK_NAME="set key repeat"
catchout res  defaults_set_int NSGlobalDomain KeyRepeat 2
log_task_from_res "$res"

CURRENT_TASK_NAME="set initial key repeat"
catchout res  defaults_set_int NSGlobalDomain InitialKeyRepeat 15
log_task_from_res "$res"

CURRENT_TASK_NAME="do not close window when app quit"
catchout res  defaults_set_bool NSGlobalDomain NSQuitAlwaysKeepsWindows 1
log_task_from_res "$res"

CURRENT_TASK_NAME="do not automatically rearrange spaces based on most recent use"
catchout res  defaults_set_bool com.apple.dock mru-spaces 0
log_task_from_res "$res"

CURRENT_TASK_NAME="group windows by app in expose"
catchout res  defaults_set_bool com.apple.dock expose-group-apps 1
log_task_from_res "$res"

CURRENT_TASK_NAME="do not switch to space w/ open window for app when app activates"
catchout res  defaults_set_bool NSGlobalDomain AppleSpacesSwitchOnActivate 0
log_task_from_res "$res"
