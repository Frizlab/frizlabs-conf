# Creates the missing folders w/ correct perms/acls/flags

expected_acl="group:everyone deny delete"

RES=; RES_LIST=()
start_task "clt dir"
{                               res_check "$RES" &&   catchout RES folder "$CLT_DIR" "700"             && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES acl    "$CLT_DIR" "$expected_acl"   && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES flags  "$CLT_DIR" "hidden"          && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

start_task ".config dir"
{                               res_check "$RES" &&   catchout RES folder "$HOME/.config" "700"             && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES acl    "$HOME/.config" "$expected_acl"   && RES_LIST+=("$RES") }
{ test "$HOST_OS" = "Darwin" && res_check "$RES" &&   catchout RES flags  "$HOME/.config" "hidden"          && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST

if test "$HOST_OS" = "Darwin"; then
	RES=; RES_LIST=()
	start_task "app dir"
	{ res_check "$RES" &&   catchout RES folder "$APP_DIR" "700"             && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES acl    "$APP_DIR" "$expected_acl"   && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
fi
