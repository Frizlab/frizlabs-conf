# Files and folders-related utilities

## Make sure the given folder exists with given permission
## Usage: libfiles__folder folder_name permission
## Example: libfiles__folder /var/log 755
function libfiles__folder() {
	local -r folder_name="$1" permission="$2"
	# %Lp format is for Darwin, %a is for Linux.
	# Linux version must be first because -f option is known by Linux stat but does not mean the same thing.
	run_and_log test -d "$folder_name" && run_and_log test "$(run_and_log_keep_stdout "$STAT" -c %a -- "$folder_name" || run_and_log_keep_stdout "$STAT" -f %Lp -- "$folder_name")" = "$permission" && { echo "ok"; return }
	run_and_log "$MKDIR" -p --            "$folder_name" || { log_task_failure "cannot create folder at path $folder_name";             echo "failed"; return }
	run_and_log "$CHMOD" -- "$permission" "$folder_name" || { log_task_failure "cannot set permission for folder at path $folder_name"; echo "failed"; return }
	echo "changed"
}

## Make sure the given file or folder has the correct ACLs
## Usage: libfiles__acl file_or_folder acl
## Example: libfiles__acl /var/log "group:everyone deny delete"
function libfiles__acl() {
	local -r file_name="$1" acl="$2"
	
	run_and_log test -e "$file_name" || { log_task_failure "cannot set ACL for file at path $file_name: file not found"; echo "failed"; return }
	run_and_log test "$(run_and_log_keep_stdout "$LS" -led -- "$file_name" | run_and_log_keep_stdout "$TAIL" -n+2 | run_and_log_keep_stdout "$SED" -E -e 's/^[ \t]*//g' -e 's/[ \t]*$//g')" = "0: $acl" && { echo "ok"; return }
	
	run_and_log "$CHMOD" -E "$file_name" <<<"$acl" || { log_task_failure "cannot set ACL for file at path $file_name"; echo "failed"; return }
	echo "changed"
}

## Make sure the given file or folder has at least the given flag
## Usage: libfiles__flags file_or_folder flag
## Example: libfiles__flags /var/log "hidden"
function libfiles__flags() {
	local -r file_name="$1" flag="$2"
	
	run_and_log test -e "$file_name" || { log_task_failure "cannot set flag for file at path $file_name: file not found"; echo "failed"; return }
	run_and_log "$GREP" -q -- "$flag" <<<"$(run_and_log_keep_stdout "$STAT" -f %Sf -- "$file_name")" && { echo "ok"; return }
	
	run_and_log "$CHFLAGS" -- "$flag" "$file_name" || { log_task_failure "cannot set flag for file at path $file_name"; echo "failed"; return }
	echo "changed"
}

## Make sure the given file does not exist. Fails if the given path is a folder.
## Usage: libfiles__delete_file file
## Example: libfiles__delete_file "$HOME/.obsolete"
function libfiles__delete_file() {
	local -r file_name="$1"
	
	run_and_log test -e "$file_name" || { echo "ok"; return }
	run_and_log test ! -d "$file_name" || { log_task_failure "not deleting folder $file_name"; echo "failed"; return }
	
	run_and_log "$RM" -f -- "$file_name" || { log_task_failure "$RM failed for $file_name"; echo "failed"; return }
	echo "changed"
}

##
## Usage: copy src dest mode
## In practice the linknbk function should be preferred over a copy.
## Example: copy ./_.bashrc.scp ~/.bashrc 600
function copy() {
	local -r src="$1"
	local -r dest="$2"
	local -r mode="$3"
	
	# First we check the destination file is not a folder
	test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	"$DIFF" -- "$src" "$dest" >/dev/null 2>&1 && test "$("$STAT" -c %a -- "$dest" 2>/dev/null || "$STAT" -f %Lp -- "$dest" 2>/dev/null)" = "$mode" && { echo "ok"; return }
	
	"$CP" -f -- "$src" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot copy file to expected location"; echo "failed"; return }
	"$CHMOD" -- "$mode" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot set permission for file at path $dest"; echo "failed"; return }
	echo "changed"
}

##
## Usage: decrypt_and_copy src dest mode
## Example: decrypt_and_copy ./_.bashrc.scp ~/.bashrc 600
function decrypt_and_copy() {
	local -r src="$1"
	local -r dest="$2"
	local -r mode="$3"
	
	# First we check the destination file is not a folder
	test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	# Then we decrypt the source file at a temporary location
	decrcpy_tmpfile="$(mktemp)" || { log_task_failure "cannot create temporary file"; echo "failed"; return }
	"$CP" -f -- "$src" "$decrcpy_tmpfile" >/dev/null 2>&1 || { "$RM" -f -- "$decrcpy_tmpfile" >/dev/null 2>&1; log_task_failure "cannot copy script to temporary file"; echo "failed"; return }
	decrypt --suffix "" -- "$decrcpy_tmpfile" || { "$RM" -f -- "$decrcpy_tmpfile" >/dev/null 2>&1; log_task_failure "cannot decrypt script"; echo "failed"; return }
	
	"$DIFF" -- "$decrcpy_tmpfile" "$dest" >/dev/null 2>&1 && test "$("$STAT" -c %a -- "$dest" 2>/dev/null || "$STAT" -f %Lp -- "$dest" 2>/dev/null)" = "$mode" && { "$RM" -f -- "$decrcpy_tmpfile" >/dev/null 2>&1; echo "ok"; return }
	
	"$MV" -f -- "$decrcpy_tmpfile" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot move decrypted file to expected location"; echo "failed"; return }
	"$CHMOD" -- "$mode" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot set permission for file at path $dest"; echo "failed"; return }
	echo "changed"
}
