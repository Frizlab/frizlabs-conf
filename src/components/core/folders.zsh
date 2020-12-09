# Creates the missing folders w/ correct perms/acls/flags

expected_acl="group:everyone deny delete"

res=; res_list=()
CURRENT_TASK_NAME="clt dir"
{                               res_check "$res" &&   catchout res folder "$CLT_DIR" "700"             && res_list+=("$res") } || true
{ test "$HOST_OS" = "Darwin" && res_check "$res" &&   catchout res acl    "$CLT_DIR" "$expected_acl"   && res_list+=("$res") } || true
{ test "$HOST_OS" = "Darwin" && res_check "$res" &&   catchout res flags  "$CLT_DIR" "hidden"          && res_list+=("$res") } || true
log_task_from_res_list res_list

if test "$HOST_OS" = "Darwin"; then
	res=; res_list=()
	CURRENT_TASK_NAME="app dir"
	{ res_check "$res" &&   catchout res folder "$APP_DIR" "700"             && res_list+=("$res") } || true
	{ res_check "$res" &&   catchout res acl    "$APP_DIR" "$expected_acl"   && res_list+=("$res") } || true
	log_task_from_res_list res_list
fi
