# Setup some defaults for Xcode


### Navigation ###

start_task "Xcode: set jump to definition on cmd-click"
catchout RES  libdefaults__set_int com.apple.dt.Xcode IDECommandClickOnCodeAction 1
log_task_from_res "$RES"

# These two are more or less bound (when the first one is changed in UI, the second one changes usually).
start_task "Xcode: set navigation style to “open in place”"
catchout RES  libdefaults__set_str com.apple.dt.Xcode IDEEditorNavigationStyle_DefaultsKey IDEEditorNavigationStyle_OpenInPlace
log_task_from_res "$RES"
start_task "Xcode: set double-click navigation to “same as click”"
catchout RES  libdefaults__set_str com.apple.dt.Xcode IDEEditorCoordinatorTarget_DoubleClick SameAsClick
log_task_from_res "$RES"


### Text Editing – Display ###

start_task "Xcode: set show code folding ribbon"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowFoldingSidebar 1
log_task_from_res "$RES"

start_task "Xcode: set show page guide"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowPageGuide 1
log_task_from_res "$RES"

start_task "Xcode: set page guide location"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextPageGuideLocation 80
log_task_from_res "$RES"

start_task "Xcode: set nowrap"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextEditorWrapsLines 0
log_task_from_res "$RES"


### Text Editing – Editing ###

start_task "Xcode: set no auto-insert braces"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextAutoInsertCloseBrace 0
log_task_from_res "$RES"

start_task "Xcode: set no auto-balance brackets in ObjC"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextAutoInsertOpenBracket 0
log_task_from_res "$RES"

start_task "Xcode: set no auto-enclose selection in delimiters"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextAutoEncloseSelectionInDelimiters 0
log_task_from_res "$RES"


### Text Editing – Indentation ###

start_task "Xcode: set indent with tabs"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentUsingTabs 1
log_task_from_res "$RES"

start_task "Xcode: set tab width"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextIndentTabWidth 3
log_task_from_res "$RES"

start_task "Xcode: set indent width"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextIndentWidth 3
log_task_from_res "$RES"

start_task "Xcode: set indent on paste"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentOnPaste 1
log_task_from_res "$RES"

start_task "Xcode: set indent Swift switch cases"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentCase 1
log_task_from_res "$RES"

start_task "Xcode: set solo brace indent width"
catchout RES  libdefaults__set_int com.apple.dt.Xcode DVTTextSoloBraceIndentWidth 3
log_task_from_res "$RES"

start_task "Xcode: set indent C switch cases"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextIndentCaseInC 1
log_task_from_res "$RES"


### Text Editor ###

start_task "Xcode: set hide Minimap"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowMinimap 0
log_task_from_res "$RES"

start_task "Xcode: set show invisibles"
catchout RES  libdefaults__set_bool com.apple.dt.Xcode DVTTextShowInvisibleCharacters 1
log_task_from_res "$RES"

start_task "Xcode: set side-by-side comparison for code review"
catchout RES  libdefaults__set_int com.apple.dt.Xcode IDEEditorDefaultCodeReviewPreference 1
log_task_from_res "$RES"


### Key Bindings ###

# Note: We could copy instead of link the idekeybindings file as Xcode first remove the file then rewrites it when it modifies it.
start_task "Xcode: set smart beginning and ending of lines"
local -r KB_DEST_FOLDER="$HOME/Library/Developer/Xcode/UserData/KeyBindings"
local -r KB_BACKUP_FOLDER="$HOME/Library/Developer/Xcode/UserData/KeyBindingsBackups"
{ res_check "$RES" &&   catchout RES  libfiles__linknbk "$COMPONENT_ROOT_FOLDER/files/Xcode/Frizlab.idekeybindings" "$KB_DEST_FOLDER/Frizlab.idekeybindings" "644" "$KB_BACKUP_FOLDER" "755"   && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_str com.apple.dt.Xcode IDEKeyBindingCurrentPreferenceSet Frizlab.idekeybindings                                                         && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST


### Font and Color Themes ###

# Note: AFAIK we could install the modified Xcode themes w/ the same name as the builtin ones; Xcode would use the modified ones.
#       Might be a future TODO as having an explicit variant of the theme is good for clarity, but in our case not really necessary.
defaults_task__install_modified_xcode_theme "Default (Dark)"  "Default + Frizlab (Dark)"  "${DEFAULTS__XCODE_THEME_ACTIONS[@]}"
defaults_task__install_modified_xcode_theme "Default (Light)" "Default + Frizlab (Light)" "${DEFAULTS__XCODE_THEME_ACTIONS[@]}"

start_task "Xcode: set dark theme to “Default + Frizlab (Dark)”"
catchout RES  libdefaults__set_str com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme "Default + Frizlab (Dark).xccolortheme"
log_task_from_res "$RES"
start_task "Xcode: set light theme to “Default + Frizlab (Light)”"
catchout RES  libdefaults__set_str com.apple.dt.Xcode XCFontAndColorCurrentTheme "Default + Frizlab (Light).xccolortheme"
log_task_from_res "$RES"


### Other ###

start_task "Xcode: link template macros from conf folder to Xcode user data"
local -r TM_DEST_FILE="$HOME/Library/Developer/Xcode/UserData/IDETemplateMacros.plist"
local -r TM_BACKUP_FOLDER="$HOME/Library/Developer/Xcode/UserData/IDETemplateMacrosBackups"
catchout RES  libfiles__linknbk "$COMPONENT_ROOT_FOLDER/files/Xcode/IDETemplateMacros.plist" "$TM_DEST_FILE" "644" "$TM_BACKUP_FOLDER" "755"
log_task_from_res "$RES"

start_task "Xcode: link code snippets from conf folder to Xcode user data"
local -r CS_DEST_FOLDER="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
local -r CS_BACKUP_FOLDER="$HOME/Library/Developer/Xcode/UserData/CodeSnippetsBackups"
catchout RES  libfiles__linknbk "$COMPONENT_ROOT_FOLDER/files/Xcode/CodeSnippets" "$CS_DEST_FOLDER" "755" "$CS_BACKUP_FOLDER" "755"
log_task_from_res "$RES"

start_task "Xcode: link templates from conf folder to Xcode folder"
local -r TPL_DEST_FOLDER="$HOME/Library/Developer/Xcode/Templates"
local -r TPL_BACKUP_FOLDER="$HOME/Library/Developer/Xcode/TemplatesBackups"
catchout RES  libfiles__linknbk "$COMPONENT_ROOT_FOLDER/files/Xcode/Templates" "$TPL_DEST_FOLDER" "755" "$TPL_BACKUP_FOLDER" "755"
log_task_from_res "$RES"
