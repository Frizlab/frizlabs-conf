# Link-related utilities

## Link the given file to the given destination, backuping the destination if it
## already existed. The backup folder must already exist.
## link_mode is mostly useless (ignored on most fs) and is fully ignored on
## Linux as it is not possible to change the perm of a link w/ chmod on it (says
## the man).
## Usage: linknbk src dest link_mode backup_folder
## Example: linknbk ./_.bashrc ~/.bashrc 600 ~/.dotfiles_backup
function linknbk() {
	src="$1"
	dest="$2"
	lnkmode="$3"
	bkfolder="$4"
	
	test -e "$src" || { log_task_failure "destination file does not exist"; echo "failed"; return }
	test -e "$dest" && ! test -L "$dest" && {
		mv "$dest" "$bkfolder" >/dev/null 2>&1 || { log_task_failure "cannot backup existing file when linking"; echo "failed"; return }
	}
	test "$(readlink "$dest" 2>/dev/null)" = "$src" && { test "$HOST_OS" != "Darwin" || test "$(stat -f %Lp "$dest" 2>/dev/null)" = "$lnkmode" } && { echo "ok"; return }
	
	ln -sf "$src" "$dest" >/dev/null 2>&1 || { log_task_failure "ln failed"; echo "failed"; return }
	{ test "$HOST_OS" != "Darwin" || chmod -h "$lnkmode" "$dest" >/dev/null 2>&1 } || { log_task_failure "cannot set permission for folder at path $folder_name"; echo "failed"; return }
	echo "changed"
}