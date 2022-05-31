# Setup some defaults for Xcode


### Navigation ###

start_task "set jump to definition on cmd-click in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode IDECommandClickOnCodeAction 1
log_task_from_res "$RES"

# These two are more or less bound (when the first one is changed in UI, the second one changes usually).
start_task "set navigation style to “open in place” in Xcode"
catchout RES  libdefaults__set_str com.apple.dt.Xcode IDEEditorNavigationStyle_DefaultsKey IDEEditorNavigationStyle_OpenInPlace
log_task_from_res "$RES"
start_task "set double-click navigation to “same as click” in Xcode"
catchout RES  libdefaults__set_str com.apple.dt.Xcode IDEEditorCoordinatorTarget_DoubleClick SameAsClick
log_task_from_res "$RES"


### Text Editing – Display ###

start_task "set show code folding ribbon in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowFoldingSidebar 1
log_task_from_res "$RES"

start_task "set show page guide in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowPageGuide 1
log_task_from_res "$RES"

start_task "set page guide location in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextPageGuideLocation 80
log_task_from_res "$RES"

start_task "set nowrap in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextEditorWrapsLines 0
log_task_from_res "$RES"


### Text Editing – Editing ###

start_task "set no auto-insert braces in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextAutoInsertCloseBrace 0
log_task_from_res "$RES"

start_task "set no auto-balance brackets in ObjC in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextAutoInsertOpenBracket 0
log_task_from_res "$RES"

start_task "set no auto-enclose selection in delimiters in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextAutoEncloseSelectionInDelimiters 0
log_task_from_res "$RES"


### Text Editing – Indentation ###

start_task "set indent with tabs in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentUsingTabs 1
log_task_from_res "$RES"

start_task "set tab width in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextIndentTabWidth 3
log_task_from_res "$RES"

start_task "set indent width in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextIndentWidth 3
log_task_from_res "$RES"

start_task "set indent on paste in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentOnPaste 1
log_task_from_res "$RES"

start_task "set indent Swift switch cases in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentCase 1
log_task_from_res "$RES"

start_task "set solo brace indent width in Xcode"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextSoloBraceIndentWidth 3
log_task_from_res "$RES"

start_task "set indent C switch cases in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentCaseInC 1
log_task_from_res "$RES"


### Text Editor ###

start_task "set hide Minimap in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowMinimap 0
log_task_from_res "$RES"

start_task "set show invisibles in Xcode"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowInvisibleCharacters 1
log_task_from_res "$RES"


### Key Bindings ###

start_task "set smart beginning and ending of lines in Xcode"
{ res_check "$RES" &&   catchout RES  libfiles__linknbk "$COMPONENT_ROOT_FOLDER/files/Frizlab.idekeybindings" "$HOME/Library/Developer/Xcode/UserData/KeyBindings/Frizlab.idekeybindings" "644" ""   && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_str com.apple.dt.Xcode IDEKeyBindingCurrentPreferenceSet Frizlab.idekeybindings                                                               && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST
