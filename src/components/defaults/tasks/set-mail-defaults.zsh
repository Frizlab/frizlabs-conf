# Setup some defaults for Mail

start_task "reverse conversations order in Mail"
catchout RES  libdefaults__set_bool com.apple.mail ConversationViewSortDescending 1
log_task_from_res "$RES"

start_task "3 snippet lines in Mail"
catchout RES  libdefaults__set_int com.apple.mail NumberOfSnippetLines 3
log_task_from_res "$RES"
