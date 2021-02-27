# Setup some macOS defaults

CURRENT_TASK_NAME="set key repeat"
catchout RES  defaults_set_int NSGlobalDomain KeyRepeat 2
log_task_from_res "$RES"

CURRENT_TASK_NAME="set initial key repeat"
catchout RES  defaults_set_int NSGlobalDomain InitialKeyRepeat 15
log_task_from_res "$RES"

RES=; RES_LIST=()
CURRENT_TASK_NAME="enable tap to click"
# So! There are three domains. My _guess_ is one is for externally connected
# bluetooth trackpads, the second is for the built-in trackpad on laptops, and
# the third is for the UI (in System Preferences).
# After verification, first domain works for built-in trackpad _and_ external
# trackpad, so I don’t know what the second domain is for. The third does change
# the UI in System Preferences.
{ res_check "$RES" &&   catchout RES  defaults_set_bool              com.apple.AppleMultitouchTrackpad                  Clicking                    1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_bool              com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking                    1 && RES_LIST+=("$RES") }
# Also activate dragging and drag lock in UI. 2 is w/o drag lock, 1 is w/o both.
{ res_check "$RES" &&   catchout RES  defaults_set_int  -currentHost NSGlobalDomain                                     com.apple.mouse.tapBehavior 3 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

RES=; RES_LIST=()
CURRENT_TASK_NAME="enable dragging"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  defaults_set_bool com.apple.AppleMultitouchTrackpad                  Dragging 1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging 1 && RES_LIST+=("$RES") }
# Third domain already done w/ “enable tap to click”
log_task_from_res_list RES_LIST

RES=; RES_LIST=()
CURRENT_TASK_NAME="enable drag lock"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  defaults_set_bool com.apple.AppleMultitouchTrackpad                  DragLock 1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock 1 && RES_LIST+=("$RES") }
# Third domain already done w/ “enable tap to click”
log_task_from_res_list RES_LIST

RES=; RES_LIST=()
CURRENT_TASK_NAME="set swipe between pages with three fingers (and between spaces with four fingers)"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  defaults_set_int              com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerHorizSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int              com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int -currentHost NSGlobalDomain                                     com.apple.trackpad.threeFingerHorizSwipeGesture 1 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

CURRENT_TASK_NAME="disable swipe between pages with two fingers"
# Surprisingly, it seems only one domain is needed there
catchout RES  defaults_set_bool NSGlobalDomain AppleEnableSwipeNavigateWithScrolls 0
log_task_from_res "$RES"

RES=; RES_LIST=()
CURRENT_TASK_NAME="set vertical swipe to four fingers"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  defaults_set_int              com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerVertSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int              com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int -currentHost NSGlobalDomain                                     com.apple.trackpad.threeFingerVertSwipeGesture 1 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

CURRENT_TASK_NAME="do not close window when app quit"
catchout RES  defaults_set_bool NSGlobalDomain NSQuitAlwaysKeepsWindows 1
log_task_from_res "$RES"

CURRENT_TASK_NAME="do not automatically rearrange spaces based on most recent use"
catchout RES  defaults_set_bool com.apple.dock mru-spaces 0
log_task_from_res "$RES"

CURRENT_TASK_NAME="enable app exposé trackpad gesture"
catchout RES  defaults_set_bool com.apple.dock showAppExposeGestureEnabled 1
log_task_from_res "$RES"

CURRENT_TASK_NAME="group windows by app in exposé"
catchout RES  defaults_set_bool com.apple.dock expose-group-apps 1
log_task_from_res "$RES"

CURRENT_TASK_NAME="do not switch to space w/ open window for app when app activates"
catchout RES  defaults_set_bool NSGlobalDomain AppleSpacesSwitchOnActivate 0
log_task_from_res "$RES"

CURRENT_TASK_NAME="cycle through all UI elements w/ tab"
catchout RES  defaults_set_int NSGlobalDomain AppleKeyboardUIMode 2
log_task_from_res "$RES"

CURRENT_TASK_NAME="ctrl-1 to go to first space"
catchout RES  ./helpers/activate-global-symbolic-hot-key.swift 118 2>/dev/null || log_task_failure "error while running activate-global-symbolic-hot-key (do you have Xcode installed?)"
log_task_from_res "$RES"

RES=; RES_LIST=()
CURRENT_TASK_NAME="set top-left corner action"
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-tl-corner   2 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-tl-modifier 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

RES=; RES_LIST=()
CURRENT_TASK_NAME="set top-right corner action"
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-tr-corner   12 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-tr-modifier  0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

RES=; RES_LIST=()
CURRENT_TASK_NAME="set bottom-right corner action"
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-br-corner   6 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-br-modifier 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

RES=; RES_LIST=()
CURRENT_TASK_NAME="set bottom-left corner action"
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-bl-corner   5 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  defaults_set_int com.apple.dock wvous-bl-modifier 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST


######### Mail #########

CURRENT_TASK_NAME="reverse conversations order in Mail"
catchout RES  defaults_set_bool com.apple.mail ConversationViewSortDescending 1
log_task_from_res "$RES"

CURRENT_TASK_NAME="3 snippet lines in Mail"
catchout RES  defaults_set_int com.apple.mail NumberOfSnippetLines 3
log_task_from_res "$RES"


######### Safari #########

CURRENT_TASK_NAME="set Safari search engine"
catchout RES  defaults_set_str com.apple.Safari SearchProviderIdentifier com.duckduckgo
log_task_from_res "$RES"


######### TextEdit #########

CURRENT_TASK_NAME="set default document type in TextEdit to text"
catchout RES  defaults_set_int com.apple.TextEdit RichText 0
log_task_from_res "$RES"
