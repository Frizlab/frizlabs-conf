# Files and folders-related utilities

## Make sure the given folder exists with given permission
## Usage: folder folder_name permission
## Example: folder /var/log 755
function folder() {
	folder_name="$1"; permission="$2"
	test -d "$folder_name" && test "$(stat -f %Lp "$folder_name")" = "$permission" && { echo "ok"; return }
	{ mkdir -p            "$folder_name" >/dev/null 2>&1 } || { log_task_failure "cannot create folder at path $folder_name";             echo "failed"; return }
	{ chmod "$permission" "$folder_name" >/dev/null 2>&1 } || { log_task_failure "cannot set permission for folder at path $folder_name"; echo "failed"; return }
	echo "changed"
}
