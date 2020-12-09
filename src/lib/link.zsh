# Link-related utilities

## Link the given file to the given destination, backuping the destination if it
## already existed. The backup folder must already exist.
## Usage: linknbk src dest backup_folder
## Example: linknbk ./_.bashrc ~/.bashrc ~/.dotfiles_backup
function linknbk() {
	src="$1"
	dest="$2"
	bkfolder="$3"
	
	test -e "$src" || { log_task_failure "destination file does not exist"; echo "failed"; return }
	test -e "$dest" && ! test -L "$dest" && {
		mv "$dest" "$bkfolder" >/dev/null 2>&1 || { log_task_failure "cannot backup existing file when linking"; echo "failed"; return }
	}
	test "$(readlink "$dest" 2>/dev/null)" = "$src" && { echo "ok"; return }
	
	ln -sf "$src" "$dest" >/dev/null 2>&1 || { log_task_failure "ln failed"; echo "failed"; return }
	echo "changed"
}
