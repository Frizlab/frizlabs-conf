# Creates the missing folders w/ correct perms/acls/flags

res=; res_list=()
CURRENT_TASK_NAME="clt dir"
{ res_check "$res" &&   res="$(folder "$CLT_DIR" "700")"   && res_list+=("$res") } || true
log_task_from_res_list "$res_list"

if test "$HOST_OS" = "Darwin"; then
	res=; res_list=()
	CURRENT_TASK_NAME="app dir"
	{ res_check "$res" &&   res="$(folder "$APP_DIR" "700")"   && res_list+=("$res") } || true
	log_task_from_res_list "$res_list"
fi
