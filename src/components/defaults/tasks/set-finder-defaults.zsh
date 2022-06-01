# Setup some defaults for the Finder


### General ###

start_task "set show hard drive on the desktop in the Finder"
catchout RES  libdefaults__set_bool com.apple.finder ShowHardDrivesOnDesktop 1
log_task_from_res "$RES"

start_task "set show connected servers on the desktop in the Finder"
catchout RES  libdefaults__set_bool com.apple.finder ShowMountedServersOnDesktop 1
log_task_from_res "$RES"


### Advanced ###

start_task "set no warn on empty trash in the Finder"
catchout RES  libdefaults__set_bool com.apple.finder WarnOnEmptyTrash 0
log_task_from_res "$RES"

start_task "set search from current folder in the Finder"
catchout RES  libdefaults__set_str com.apple.finder FXDefaultSearchScope SCcf
log_task_from_res "$RES"
