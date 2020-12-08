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

## Make sure the given file or folder has the correct ACLs
## Usage: acl file_or_folder acl
## Example: acl /var/log "group:everyone deny delete"
function acl() {
	file_name="$1"; acl="$2"
	
	test -e "$file_name" || { log_task_failure "cannot set ACL for file at path $file_name: file not found"; echo "failed"; return }
	test "$(ls -led "$file_name" 2>/dev/null | tail -n+2 | sed -E -e 's/^[ \t]*//g' -e 's/[ \t]*$//g')" = "0: $acl" && { echo "ok"; return }
	
	chmod -E "$file_name" >/dev/null 2>&1 <<<"$acl" || { log_task_failure "cannot set ACL for file at path $file_name"; echo "failed"; return }
	echo "changed"
}

## Make sure the given file or folder has at least the given flag
## Usage: acl file_or_folder flag
## Example: acl /var/log "hidden"
function flags() {
	file_name="$1"; flag="$2"
	
	test -e "$file_name" || { log_task_failure "cannot set flag for file at path $file_name: file not found"; echo "failed"; return }
	grep -q "$flag" <<<"$(stat -f %Sf "$file_name")" && { echo "ok"; return }
	
	chflags "$flag" "$file_name" || { log_task_failure "cannot set flag for file at path $file_name"; echo "failed"; return }
	echo "changed"
}
