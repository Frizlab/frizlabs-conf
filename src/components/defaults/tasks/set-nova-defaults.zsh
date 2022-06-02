# Setup some defaults for Nova

start_task "set tab width in Nova"
catchout RES  libdefaults__set_float com.panic.Nova TabWidth 3
log_task_from_res "$RES"

start_task "set nowrap in Nova"
catchout RES  libdefaults__set_bool com.panic.Nova WrapLines 0
log_task_from_res "$RES"

start_task "set show invisibles in Nova"
catchout RES  libdefaults__set_bool com.panic.Nova ShowInvisibleCharacters 1
log_task_from_res "$RES"

start_task "set hide indentation guides in Nova"
catchout RES  libdefaults__set_bool com.panic.Nova ShowIndentationGuides 0
log_task_from_res "$RES"

start_task "set overscroll to medium in Nova"
catchout RES  libdefaults__set_int com.panic.Nova ExtendContentBeyondLastLine 2
log_task_from_res "$RES"

start_task "set noscroll in file navigator on file change in Nova"
catchout RES  libdefaults__set_int com.panic.Nova FilesAutomaticallySelectFocused 1
log_task_from_res "$RES"
