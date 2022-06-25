# Setup some defaults for Nova

start_task "Nova: set tab width"
catchout RES  libdefaults__set_float com.panic.Nova TabWidth 3
log_task_from_res "$RES"

start_task "Nova: set nowrap"
catchout RES  libdefaults__set_bool com.panic.Nova WrapLines 0
log_task_from_res "$RES"

start_task "Nova: set show invisibles"
catchout RES  libdefaults__set_bool com.panic.Nova ShowInvisibleCharacters 1
log_task_from_res "$RES"

start_task "Nova: set hide indentation guides"
catchout RES  libdefaults__set_bool com.panic.Nova ShowIndentationGuides 0
log_task_from_res "$RES"

start_task "Nova: set overscroll to medium"
catchout RES  libdefaults__set_int com.panic.Nova ExtendContentBeyondLastLine 2
log_task_from_res "$RES"

start_task "Nova: set noscroll in file navigator on file change"
catchout RES  libdefaults__set_int com.panic.Nova FilesAutomaticallySelectFocused 1
log_task_from_res "$RES"

start_task "Nova: do not show launch window on last window close"
catchout RES  libdefaults__set_bool com.panic.Nova ShowWelcomeOnLastWindowClosed 0
log_task_from_res "$RES"
