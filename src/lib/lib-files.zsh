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
## Usage: libfiles__copy src dest mode
## In practice the linknbk function should be preferred over a copy.
## Example: libfiles__copy ./_.bashrc.scp ~/.bashrc 600
function libfiles__copy() {
	local -r src="$1"
	local -r dest="$2"
	local -r mode="$3"
	
	# First we check the destination file is not a folder
	run_and_log test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	run_and_log "$DIFF" -- "$src" "$dest" && run_and_log test "$(run_and_log_keep_stdout "$STAT" -c %a -- "$dest" || run_and_log_keep_stdout "$STAT" -f %Lp -- "$dest")" = "$mode" && { echo "ok"; return }
	
	run_and_log "$CP" -f -- "$src" "$dest" || { log_task_failure "cannot copy file to expected location"; echo "failed"; return }
	run_and_log "$CHMOD" -- "$mode" "$dest" || { log_task_failure "cannot set permission for file at path $dest"; echo "failed"; return }
	echo "changed"
}

##
## Usage: libfiles__decrypt_and_copy src dest mode
## Example: libfiles__decrypt_and_copy ./_.bashrc.scp ~/.bashrc 600
function libfiles__decrypt_and_copy() {
	local -r src="$1"
	local -r dest="$2"
	local -r mode="$3"
	
	# First we check the destination file is not a folder
	run_and_log test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	# Then we decrypt the source file at a temporary location
	decrcpy_tmpfile="$(run_and_log_keep_stdout mktemp)" || { log_task_failure "cannot create temporary file"; echo "failed"; return }
	run_and_log "$CP" -f -- "$src" "$decrcpy_tmpfile"     || { run_and_log "$RM" -f -- "$decrcpy_tmpfile" || true; log_task_failure "cannot copy script to temporary file"; echo "failed"; return }
	run_and_log libccrypt__decrypt --suffix "" -- "$decrcpy_tmpfile" || { run_and_log "$RM" -f -- "$decrcpy_tmpfile" || true; log_task_failure "cannot decrypt script"; echo "failed"; return }
	
	run_and_log "$DIFF" -- "$decrcpy_tmpfile" "$dest" && run_and_log test "$(run_and_log_keep_stdout "$STAT" -c %a -- "$dest" || run_and_log_keep_stdout "$STAT" -f %Lp -- "$dest")" = "$mode" && { run_and_log "$RM" -f -- "$decrcpy_tmpfile" || true; echo "ok"; return }
	
	run_and_log "$MV" -f -- "$decrcpy_tmpfile" "$dest" || { log_task_failure "cannot move decrypted file to expected location"; echo "failed"; return }
	run_and_log "$CHMOD" -- "$mode" "$dest" || { log_task_failure "cannot set permission for file at path $dest"; echo "failed"; return }
	echo "changed"
}

## Soft create link at dst, pointing to src.
## Check src exists first.
## Fails if dst already exists and is not a link.
## On macOS, gives the link the given mode.
## Usage: lnk ~/clt/homebrew-arm64 ~/clt/homebrew 755
function libfiles__lnk() {
	local -r src="$1"
	local -r dst="$2"
	local -r lnkmode="$3"
	
	run_and_log test -e "$src" || { log_task_failure "destination file does not exist"; echo "failed"; return }
	run_and_log test ! -e "$dst" || run_and_log test -L "$dst" || { log_task_failure "destination already exists and is not a link"; echo "failed"; return }
	run_and_log test "$(run_and_log_keep_stdout "$READLINK" -- "$dst")" = "$src" && { test "$HOST_OS" != "Darwin" || run_and_log test "$(run_and_log_keep_stdout "$STAT" -f %Lp -- "$dst")" = "$lnkmode" } && { echo "ok"; return }
	
	run_and_log "$LN" -sf -- "$src" "$dst" || { log_task_failure "$LN failed"; echo "failed"; return }
	{ test "$HOST_OS" != "Darwin" || run_and_log "$CHMOD" -h -- "$lnkmode" "$dst" } || { log_task_failure "cannot set permission for link at path $dst"; echo "failed"; return }
	echo "changed"
}

## Link the given file to the given destination, backuping the destination if it already existed.
##
## The backup folder must already exist if the destination file might exist as anything but a link (it is used in this case).
## If the destination has no chance of already existing, giving an empty string for the backup folder is ok.
##
## link_mode is mostly useless (ignored on most fs) and is fully ignored on Linux
##  as it is not possible to change the perm of a link w/ chmod on it (says the man).
##
## Usage: libfiles__linknbk src dest link_mode backup_folder
## Example: libfiles__linknbk ./_.bashrc ~/.bashrc 600 ~/.dotfiles_backup
function libfiles__linknbk() {
	local -r src="$1"
	local -r dest="$2"
	local -r lnkmode="$3"
	local -r bkfolder="$4"
	
	run_and_log test -e "$src" || { log_task_failure "destination file does not exist"; echo "failed"; return }
	run_and_log test -e "$dest" && ! run_and_log test -L "$dest" && {
		run_and_log "$MV" -- "$dest" "$bkfolder" || { log_task_failure "cannot backup existing file when linking"; echo "failed"; return }
	}
	run_and_log test "$(run_and_log_keep_stdout "$READLINK" -- "$dest")" = "$src" && { run_and_log test "$HOST_OS" != "Darwin" || run_and_log test "$(run_and_log_keep_stdout "$STAT" -f %Lp -- "$dest")" = "$lnkmode" } && { echo "ok"; return }
	
	run_and_log "$LN" -sf -- "$src" "$dest" || { log_task_failure "$LN failed"; echo "failed"; return }
	{ run_and_log test "$HOST_OS" != "Darwin" || run_and_log "$CHMOD" -h -- "$lnkmode" "$dest" } || { log_task_failure "cannot set permission for link at path $dest"; echo "failed"; return }
	echo "changed"
}

function libfiles__compilec() {
	local -r src="$1"; shift
	local -r dest="$1"; shift
	local -r cflags="$1"; shift
	
	# First we check the destination file is not a folder
	run_and_log test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	# We almost handle spaces correctly there, but not for the dependencies of the target.
	# If the target contains a space, it _must_ be in a variable AFAICT, and cannot be escaped inline.
	# The variable must be defined as such: “DEP1 := file\ with\ spaces” (aka.: “DEP1 := ${(q)dep}’)
	local n=0
	local depvarsdefs=
	for curdep in "$src" "$@"; do
		depvarsdefs="${depvarsdefs}DEP$n := ${(q)curdep}"$'\n'
		n=$((n+1))
	done
	local -r depvars="$(
		local i=0
		while [ $i -lt $n ]; do
			printf " \$(DEP$i)"
			i=$((i+1))
		done
	)"
	local -r makefile="DEST := ${(q)dest}"$'\n'"${depvarsdefs}"$'\n'"\$(DEST): $depvars"$'\n\t'"cc $cflags ${(qq)src} -o ${(qq)dest}"
	debug_log $'Makefile:\n---\n'"$makefile"$'\n---'
	
	printf -- "%s" "$makefile" | run_and_log "$MAKE" -f - -q && { echo "ok"; return }
	printf -- "%s" "$makefile" | run_and_log "$MAKE" -f -    || { log_task_failure "cannot make the destination"; echo "failed"; return }
	echo "changed"
}
