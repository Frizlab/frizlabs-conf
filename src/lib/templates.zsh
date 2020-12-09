# Template-related utilities

## 
## Usage: detemplate src dest mode
## Example: detemplate ./_.bashrc ~/.bashrc 600
function detemplate() {
	src="$1"
	dest="$2"
	mode="$3"
	
	# First we check the destination file is not a folder
	test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	# Then we detemplate the source file at a temporary location
	tmpl_tmpfile="$(mktemp)"
	m4_args=()
	OLD_IFS="$IFS"; IFS=$'\n'
	for varvalue in $(set); do
		var="${varvalue%%=*}"
		value="${varvalue#*=}"
		test "$#value" -gt 0 -a "${value:0:1}" != '(' || continue
		m4_args+=("-D___M4___${var}___M4___=$value")
	done
	IFS="$OLD_IFS"
	eval m4 --prefix-builtins --fatal-warnings "${m4_args[@]}" -- "${(q)src}" ">${(q)tmpl_tmpfile}" || { log_task_failure "cannot run m4"; echo "failed"; return }
	grep -qE '___M4___[A-Z_]*___M4___' "$tmpl_tmpfile" && { log_task_failure "it seems there are undefined variables in the file"; echo "failed"; return }
	
	# Next we move the temporary file if needed at the destination
	diff -- "$tmpl_tmpfile" "$dest" >/dev/null 2>&1 && test "$(stat -c %a "$dest" 2>/dev/null || stat -f %Lp "$dest" 2>/dev/null)" = "$mode" && { rm -f "$tmpl_tmpfile" >/dev/null 2>&1; echo "ok"; return }
	
	mv -f -- "$tmpl_tmpfile" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot move detemplated file to expected location"; echo "failed"; return }
	chmod -- "$mode" "$dest" >/dev/null 2>&1 || { log_task_failure "cannot set permission for file at path $folder_name"; echo "failed"; return }
	echo "changed"
}
