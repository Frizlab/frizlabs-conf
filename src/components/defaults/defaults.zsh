# Setup some macOS defaults

CURRENT_TASK_NAME="set key repeat"
catchout res  defaults_set_int NSGlobalDomain KeyRepeat 2
log_task_from_res "$res"

CURRENT_TASK_NAME="set initial key repeat"
catchout res  defaults_set_int NSGlobalDomain InitialKeyRepeat 15
log_task_from_res "$res"

res=; res_list=()
CURRENT_TASK_NAME="enable tap to click"
# So! There are two keys. My _guess_ is one is for externally connected
# bluetooth trackpads, the other is for the built-in trackpad on laptops.
# Currently verified: First property works on built-in trackpad, other does not.
# TODO: Verify second property works w/ external trackpad, first does not!
{ res_check "$res" &&   catchout res  defaults_set_bool com.apple.AppleMultitouchTrackpad                  Clicking 1 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 1 && res_list+=("$res") }
log_task_from_res_list res_list

res=; res_list=()
CURRENT_TASK_NAME="enable dragging"
# Two keys, same remarks as for “enable tap to click”
{ res_check "$res" &&   catchout res  defaults_set_bool com.apple.AppleMultitouchTrackpad                  Dragging 1 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging 1 && res_list+=("$res") }
log_task_from_res_list res_list

res=; res_list=()
CURRENT_TASK_NAME="enable drag lock"
# Two keys, same remarks as for “enable tap to click”
{ res_check "$res" &&   catchout res  defaults_set_bool com.apple.AppleMultitouchTrackpad                  DragLock 1 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock 1 && res_list+=("$res") }
log_task_from_res_list res_list

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

CURRENT_TASK_NAME="cycle through all UI elements w/ tab"
catchout res  defaults_set_int NSGlobalDomain AppleKeyboardUIMode 2
log_task_from_res "$res"

CURRENT_TASK_NAME="ctrl-1 to go to first space"
catchout res  ./helpers/activate-global-symbolic-hot-key.swift 118 2>/dev/null || log_task_failure "error while running activate-global-symbolic-hot-key (do you have Xcode installed?)"
log_task_from_res "$res"

res=; res_list=()
CURRENT_TASK_NAME="set top-left corner action"
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-tl-corner   2 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-tl-modifier 0 && res_list+=("$res") }
log_task_from_res_list res_list

res=; res_list=()
CURRENT_TASK_NAME="set top-right corner action"
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-tr-corner   12 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-tr-modifier  0 && res_list+=("$res") }
log_task_from_res_list res_list

res=; res_list=()
CURRENT_TASK_NAME="set bottom-right corner action"
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-br-corner   6 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-br-modifier 0 && res_list+=("$res") }
log_task_from_res_list res_list

res=; res_list=()
CURRENT_TASK_NAME="set bottom-left corner action"
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-bl-corner   5 && res_list+=("$res") }
{ res_check "$res" &&   catchout res  defaults_set_int com.apple.dock wvous-bl-modifier 0 && res_list+=("$res") }
log_task_from_res_list res_list


######### Mail #########

CURRENT_TASK_NAME="reverse conversations order in Mail"
catchout res  defaults_set_bool com.apple.mail ConversationViewSortDescending 1
log_task_from_res "$res"

CURRENT_TASK_NAME="3 snippet lines in Mail"
catchout res  defaults_set_int com.apple.mail NumberOfSnippetLines 3
log_task_from_res "$res"


######### Safari #########

CURRENT_TASK_NAME="set Safari search engine"
catchout res  defaults_set_str com.apple.Safari SearchProviderIdentifier com.duckduckgo
log_task_from_res "$res"


######### TextEdit #########

CURRENT_TASK_NAME="set default document type in TextEdit to text"
catchout res  defaults_set_int com.apple.TextEdit RichText 0
log_task_from_res "$res"
