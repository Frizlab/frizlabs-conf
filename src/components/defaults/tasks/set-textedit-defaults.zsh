# Setup some defaults for TextEdit

# It seems type of this one *is* int, not bool.
start_task "set default document type in TextEdit to text"
catchout RES  libdefaults__set_int com.apple.TextEdit RichText 0
log_task_from_res "$RES"
