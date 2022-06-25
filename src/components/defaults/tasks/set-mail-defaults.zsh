# Setup some defaults for Mail
# TODO: Enable Junk filtering (it is not in com.apple.mail defaults domain)
# TODO: For work, mark addresses not ending with a given domain (not in com.apple.mail defaults domain)

start_task "Mail: set reverse conversations order"
catchout RES  libdefaults__set_bool com.apple.mail ConversationViewSortDescending 1
log_task_from_res "$RES"

start_task "Mail: set 3 snippet lines"
catchout RES  libdefaults__set_int com.apple.mail NumberOfSnippetLines 3
log_task_from_res "$RES"

start_task "Mail: set delete attachments when Mail quits"
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool com.apple.mail DeleteAttachmentsEnabled    1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int  com.apple.mail DeleteAttachmentsAfterHours 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "Mail: set search junk mails"
catchout RES  libdefaults__set_bool com.apple.mail IndexJunk 1
log_task_from_res "$RES"

start_task "Mail: set search decrypted mails"
catchout RES  libdefaults__set_bool com.apple.mail IndexDecryptedMessages 1
log_task_from_res "$RES"

start_task "Mail: set mono-spaced font for plain text mails"
catchout RES  libdefaults__set_bool com.apple.mail AutoSelectFont 1
log_task_from_res "$RES"

start_task "Mail: set reply in same format as original mail"
catchout RES  libdefaults__set_bool com.apple.mail AutoReplyFormat 1
log_task_from_res "$RES"

start_task "Mail: set move deleted messages to the Bin"
catchout RES  libdefaults__set_int com.apple.mail SwipeAction 0
log_task_from_res "$RES"

start_task "Mail: set default message format to plain text"
catchout RES  libdefaults__set_str com.apple.mail SendFormat "Plain"
log_task_from_res "$RES"
