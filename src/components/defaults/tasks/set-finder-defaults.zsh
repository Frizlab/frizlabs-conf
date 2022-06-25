# Setup some defaults for the Finder


### General ###

start_task "Finder: set show hard drive on the desktop"
catchout RES  libdefaults__set_bool com.apple.finder ShowHardDrivesOnDesktop 1
log_task_from_res "$RES"

start_task "Finder: set show connected servers on the desktop"
catchout RES  libdefaults__set_bool com.apple.finder ShowMountedServersOnDesktop 1
log_task_from_res "$RES"


### Advanced ###

start_task "Finder: set no warn on empty trash"
catchout RES  libdefaults__set_bool com.apple.finder WarnOnEmptyTrash 0
log_task_from_res "$RES"

start_task "Finder: set search from current folder"
catchout RES  libdefaults__set_str com.apple.finder FXDefaultSearchScope SCcf
log_task_from_res "$RES"
