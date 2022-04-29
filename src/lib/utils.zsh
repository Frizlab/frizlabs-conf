## Usage: catchout stdoutvar command args...
##
## This is the question and the complicated answers to do this.
## TL;DR: Catching output of command w/ command being able to modify variables is almost impossible without temp files using bash/zsh.
## https://stackoverflow.com/q/11027679
## https://stackoverflow.com/a/41069638
## https://stackoverflow.com/a/41652679
##
## Example:
##    catchout RES my_function arg1 arg2
## This will basically do: RES="$(my_function arg1 arg2)", EXCEPT if my_function modifies a global variable, the modification will stay (using “$()” it does not).
function catchout() {
	local catchout_tmpfile; catchout_tmpfile="$(mktemp)"; readonly catchout_tmpfile
	"${@:2}" >"$catchout_tmpfile"
	local -r ret="$?"
	eval "$1=\$("$CAT" -- \"$catchout_tmpfile\")"
	"$RM" -f -- "$catchout_tmpfile" || true
	return "$ret"
}
