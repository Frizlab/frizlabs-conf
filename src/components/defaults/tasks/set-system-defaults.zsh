# Setup some macOS defaults

start_task "set key repeat"
catchout RES  libdefaults__set_int NSGlobalDomain KeyRepeat 2
log_task_from_res "$RES"

start_task "set initial key repeat"
catchout RES  libdefaults__set_int NSGlobalDomain InitialKeyRepeat 15
log_task_from_res "$RES"

start_task "enable tap to click"
# So!
# There are three domains.
# My _guess_ is the first one is for externally connected bluetooth trackpads,
# the second one is for the built-in trackpad on laptops,
# and the third one is for the UI (in System Preferences).
# After verification, first domain works for built-in trackpad _and_ external trackpad,
# so I don’t know what the second domain is for.
# The third does change the UI in System Preferences.
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool              com.apple.AppleMultitouchTrackpad                  Clicking                    1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool              com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking                    1 && RES_LIST+=("$RES") }
# Also activate dragging and drag lock in UI. 2 is w/o drag lock, 1 is w/o both.
{ res_check "$RES" &&   catchout RES  libdefaults__set_int  -currentHost NSGlobalDomain                                     com.apple.mouse.tapBehavior 3 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "enable dragging"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool com.apple.AppleMultitouchTrackpad                  Dragging 1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging 1 && RES_LIST+=("$RES") }
# Third domain already done w/ “enable tap to click”
log_task_from_res_list RES_LIST

start_task "enable drag lock"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool com.apple.AppleMultitouchTrackpad                  DragLock 1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock 1 && RES_LIST+=("$RES") }
# Third domain already done w/ “enable tap to click”
log_task_from_res_list RES_LIST

start_task "set swipe between pages with three fingers (and between spaces with four fingers)"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  libdefaults__set_int              com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerHorizSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int              com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int -currentHost NSGlobalDomain                                     com.apple.trackpad.threeFingerHorizSwipeGesture 1 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "disable swipe between pages with two fingers"
# Surprisingly, it seems only one domain is needed there
catchout RES  libdefaults__set_bool NSGlobalDomain AppleEnableSwipeNavigateWithScrolls 0
log_task_from_res "$RES"

start_task "set vertical swipe to four fingers"
# Three domains, same remarks as for “enable tap to click”
{ res_check "$RES" &&   catchout RES  libdefaults__set_int              com.apple.AppleMultitouchTrackpad                  TrackpadThreeFingerVertSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int              com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture            1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int -currentHost NSGlobalDomain                                     com.apple.trackpad.threeFingerVertSwipeGesture 1 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "do not close window when app quit"
catchout RES  libdefaults__set_bool NSGlobalDomain NSQuitAlwaysKeepsWindows 1
log_task_from_res "$RES"

start_task "do not automatically rearrange spaces based on most recent use"
catchout RES  libdefaults__set_bool com.apple.dock mru-spaces 0
log_task_from_res "$RES"

start_task "enable app exposé trackpad gesture"
catchout RES  libdefaults__set_bool com.apple.dock showAppExposeGestureEnabled 1
log_task_from_res "$RES"

start_task "group windows by app in exposé"
catchout RES  libdefaults__set_bool com.apple.dock expose-group-apps 1
log_task_from_res "$RES"

start_task "do not switch to space w/ open window for app when app activates"
catchout RES  libdefaults__set_bool NSGlobalDomain AppleSpacesSwitchOnActivate 0
log_task_from_res "$RES"

start_task "cycle through all UI elements w/ tab"
catchout RES  libdefaults__set_int NSGlobalDomain AppleKeyboardUIMode 2
log_task_from_res "$RES"

start_task "ctrl-1 to go to first space"
catchout RES  run_and_log_keep_stdout ./lib/activate-global-symbolic-hot-key.swift 118 || log_task_failure "error while running activate-global-symbolic-hot-key (do you have Xcode installed?)"
log_task_from_res "$RES"

start_task "set top-left corner action"
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-tl-corner   2 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-tl-modifier 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "set top-right corner action"
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-tr-corner   12 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-tr-modifier  0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "set bottom-right corner action"
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-br-corner   6 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-br-modifier 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "set bottom-left corner action"
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-bl-corner   5 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int com.apple.dock wvous-bl-modifier 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

# Note: I’m not fully confident this is actually used anywhere…
start_task "set system-wide search engine"
catchout RES  libdefaults__set_plist NSGlobalDomain NSPreferredWebServices '{NSWebServicesProviderWebSearch = {NSDefaultDisplayName = DuckDuckGo; NSProviderIdentifier = "com.duckduckgo";};}'
log_task_from_res "$RES"