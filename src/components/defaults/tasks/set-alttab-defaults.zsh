# Setup some defaults for AltTab


### Controls ###

start_task "set show windows from visible spaces for shortcut 1 in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos spacesToShow "1"
log_task_from_res "$RES"

start_task "set show windows from screen showing AltTab for shortcut 1 in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos screensToShow "1"
log_task_from_res "$RES"

start_task "set show minimized windows at the end for shortcut 1 in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos showMinimizedWindows "2"
log_task_from_res "$RES"

start_task "set show hidden windows at the end for shortcut 1 in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos showHiddenWindows "2"
log_task_from_res "$RES"

start_task "set select previous window shortcut for shortcut 1 in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos previousWindowShortcut $'\U2325\U21e7\U21e5'
log_task_from_res "$RES"

start_task "remove shortcut 2 in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos nextWindowShortcut2 ""
log_task_from_res "$RES"


### Appearance ###

start_task "set apparition delay in AltTab"
catchout RES  libdefaults__set_str com.lwouis.alt-tab-macos windowDisplayDelay "185"; #ms
log_task_from_res "$RES"
