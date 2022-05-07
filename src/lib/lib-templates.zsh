# Template-related utilities

##
## Usage: detemplate src dest mode
## Example: detemplate ./_.bashrc ~/.bashrc 600
function libtemplates__detemplate() {
	local -r src="$1"
	local -r dest="$2"
	local -r mode="$3"
	
	# First we check the destination file is not a folder
	test ! -d "$dest" || { log_task_failure "destination file is a folder"; echo "failed"; return }
	
	# Then we detemplate the source file at a temporary location
	local tmpl_tmpfile; tmpl_tmpfile="$(run_and_log_keep_stdout mktemp)"; readonly tmpl_tmpfile
	local m4_args=()
	local OLD_IFS="$IFS"; local IFS=$'\n'
	for varvalue in $(set); do
		local var="${varvalue%%=*}"
		local value="${varvalue#*=}"
		test "$#value" -gt 0 -a "${value:0:1}" != '(' || continue
		m4_args+=("-D___M4___${var}___M4___=$value")
	done
	IFS="$OLD_IFS"
	eval run_and_log_keep_stdout "$M4" --prefix-builtins --fatal-warnings "${m4_args[@]}" -- "${(q)src}" ">${(q)tmpl_tmpfile}" || { log_task_failure "cannot run $M4"; echo "failed"; return }
	run_and_log_keep_stdout "$GREP" -E '^[^#]' -- "$tmpl_tmpfile" | run_and_log "$GREP" -qE '___M4___[A-Za-z0-9_]*___M4___' && { log_task_failure "it seems there are undefined variables in the file"; echo "failed"; return }
	
	# Next we move the temporary file if needed at the destination
	run_and_log "$DIFF" -- "$tmpl_tmpfile" "$dest" && test "$("$STAT" -c %a -- "$dest" 2>/dev/null || "$STAT" -f %Lp -- "$dest" 2>/dev/null)" = "$mode" && { "$RM" -f -- "$tmpl_tmpfile" >/dev/null 2>&1; echo "ok"; return }
	
	run_and_log "$MV" -f -- "$tmpl_tmpfile" "$dest" || { log_task_failure "cannot move detemplated file to expected location"; echo "failed"; return }
	run_and_log "$CHMOD" -- "$mode" "$dest" || { log_task_failure "cannot set permission for file at path $dest"; echo "failed"; return }
	echo "changed"
}
