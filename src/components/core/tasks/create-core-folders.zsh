# Creates the missing core folders w/ correct perms/acls/flags

expected_acl="group:everyone deny delete"

RES=; RES_LIST=()
start_task "clt dir"
{                               res_check "$RES" &&   catchout RES libfiles__folder "$CLT_DIR" "700"             && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES libfiles__acl    "$CLT_DIR" "$expected_acl"   && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES libfiles__flags  "$CLT_DIR" "hidden"          && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task ".config dir"
{                               res_check "$RES" &&   catchout RES libfiles__folder "$HOME/.config" "700"             && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES libfiles__acl    "$HOME/.config" "$expected_acl"   && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES libfiles__flags  "$HOME/.config" "hidden"          && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

if test "$HOST_OS" = "Darwin"; then
	RES=; RES_LIST=()
	start_task "app dir"
	{ res_check "$RES" &&   catchout RES libfiles__folder "$APP_DIR" "700"             && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES libfiles__acl    "$APP_DIR" "$expected_acl"   && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
	
	RES=; RES_LIST=()
	start_task "Developer dir"
	{ res_check "$RES" &&   catchout RES libfiles__folder "$DEVELOPER_DIR" "700"             && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES libfiles__acl    "$DEVELOPER_DIR" "$expected_acl"   && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
fi

# CLT subfolders

task__folder "$CLT_ENVS_DIR" "755"
task__folder "$CLT_LOGS_DIR" "755"

task__folder "$FIRST_PARTY_BIN_DIR" "755"
task__folder "$THIRD_PARTY_BIN_DIR" "755"

task__folder "$FIRST_PARTY_SBIN_DIR" "755"
task__folder "$THIRD_PARTY_SBIN_DIR" "755"

task__folder "$FIRST_PARTY_SHARE_DIR" "755"
task__folder "$THIRD_PARTY_SHARE_DIR" "755"
