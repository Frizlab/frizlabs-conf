# Files and folders-related utilities

## Make sure the given folder exists with given permission
## Usage: folder folder_name permission
## Example: folder /var/log 755
function folder() {
	folder_name="$1"; permission="$2"
	# %Lp format is for Darwin, %a is for Linux. Linux version must be first
	# because -f option is known by Linux stat but does not mean the same thing.
	test -d "$folder_name" && test "$(stat -c %a "$folder_name" 2>/dev/null || stat -f %Lp "$folder_name" 2>/dev/null)" = "$permission" && { echo "ok"; return }
	mkdir -p            "$folder_name" >/dev/null 2>&1 || { log_task_failure "cannot create folder at path $folder_name";             echo "failed"; return }
	chmod "$permission" "$folder_name" >/dev/null 2>&1 || { log_task_failure "cannot set permission for folder at path $folder_name"; echo "failed"; return }
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
	grep -q "$flag" <<<"$(stat -f %Sf "$file_name" 2>/dev/null)" && { echo "ok"; return }
	
	chflags "$flag" "$file_name" 2>/dev/null || { log_task_failure "cannot set flag for file at path $file_name"; echo "failed"; return }
	echo "changed"
}

## Make sure the given file does not exist. Fails if the given path is a folder
## Usage: delete file
## Example: delete "$HOME/.obsolete"
function delete() {
	file_name="$1"
	
	test -e "$file_name" || { echo "ok"; return }
	test ! -d "$file_name" || { log_task_failure "not deleting folder $file_name"; echo "failed"; return }
	
	rm -f "$file_name" >/dev/null 2>&1 || { log_task_failure "rm failed for $file_name"; echo "failed"; return }
	echo "changed"
}

##
## Usage: decrypt_and_copy src dest mode
## Example: decrypt_and_copy ./_.bashrc.scp ~/.bashrc 600
function decrypt_and_copy() {
	src="$1"
	dest="$2"
	mode="$3"
	
	# First we check the destination file is not a folder
	test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	# Then we decrypt the source file at a temporary location
	decrcpy_tmpfile=$(mktemp) || { log_task_failure "cannot create temporary file"; echo "failed"; return }
	cp -f -- "$local_script_path" "$decrcpy_tmpfile" >/dev/null 2>&1 || { rm -f "$decrcpy_tmpfile" >/dev/null 2>&1; log_task_failure "cannot copy script to temporary file"; echo "failed"; return }
	decrypt --suffix "" -- "$decrcpy_tmpfile" || { rm -f "$decrcpy_tmpfile" >/dev/null 2>&1; log_task_failure "cannot decrypt script"; echo "failed"; return }
	
	diff -- "$decrcpy_tmpfile" "$dest" >/dev/null 2>&1 && test "$(stat -c %a "$dest" 2>/dev/null || stat -f %Lp "$dest" 2>/dev/null)" = "$mode" && { rm -f "$decrcpy_tmpfile" >/dev/null 2>&1; echo "ok"; return }
	
	mv -f -- "$decrcpy_tmpfile" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot move decrypted file to expected location"; echo "failed"; return }
	chmod -- "$mode" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot set permission for file at path $dest"; echo "failed"; return }
	echo "changed"
}
