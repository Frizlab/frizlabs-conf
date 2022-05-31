# Setup some defaults for Xcode

start_task "set nowrap in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextEditorWrapsLines 0
log_task_from_res "$RES"

start_task "set tab width in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextIndentTabWidth 3
log_task_from_res "$RES"

start_task "set indent width in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextIndentWidth 3
log_task_from_res "$RES"

start_task "set indent with tabs in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentUsingTabs 1
log_task_from_res "$RES"

start_task "set page guide location in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextPageGuideLocation 80
log_task_from_res "$RES"

start_task "set show page guide in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowPageGuide 1
log_task_from_res "$RES"

start_task "set show code folding ribbon in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowFoldingSidebar 1
log_task_from_res "$RES"

start_task "set indent Swift switch cases in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentCase 1
log_task_from_res "$RES"

start_task "set indent C switch cases in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentCaseInC 1
log_task_from_res "$RES"
