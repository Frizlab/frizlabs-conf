# Setup some defaults for Mail
# TODO: Enable Junk filtering (it is not in com.apple.mail defaults domain)
# TODO: For work, mark addresses not ending with a given domain (not in com.apple.mail defaults domain)

start_task "set reverse conversations order in Mail"
catchout RES  libdefaults__set_bool com.apple.mail ConversationViewSortDescending 1
log_task_from_res "$RES"

start_task "set 3 snippet lines in Mail"
catchout RES  libdefaults__set_int com.apple.mail NumberOfSnippetLines 3
log_task_from_res "$RES"

start_task "set delete attachments when Mail quits in Mail"
{ res_check "$RES" &&   catchout RES  libdefaults__set_bool com.apple.mail DeleteAttachmentsEnabled    1 && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libdefaults__set_int  com.apple.mail DeleteAttachmentsAfterHours 0 && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task "set search junk mails in Mail"
catchout RES  libdefaults__set_bool com.apple.mail IndexJunk 1
log_task_from_res "$RES"

start_task "set search decrypted mails in Mail"
catchout RES  libdefaults__set_bool com.apple.mail IndexDecryptedMessages 1
log_task_from_res "$RES"

start_task "set mono-spaced font for plain text mails in Mail"
catchout RES  libdefaults__set_bool com.apple.mail AutoSelectFont 1
log_task_from_res "$RES"

start_task "set reply in same format as original mail in Mail"
catchout RES  libdefaults__set_bool com.apple.mail AutoReplyFormat 1
log_task_from_res "$RES"

start_task "set move deleted messages to the Bin in Mail"
catchout RES  libdefaults__set_int com.apple.mail SwipeAction 0
log_task_from_res "$RES"

start_task "set default message format to plain text in Mail"
catchout RES  libdefaults__set_str com.apple.mail SendFormat "Plain"
log_task_from_res "$RES"
