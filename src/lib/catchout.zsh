# This is the question and the complicated answers to do this.
# TL;DR: Catching output of command w/ command being able to modify variables is
# almost impossible without temp files using bash/zsh.
# https://stackoverflow.com/q/11027679
# https://stackoverflow.com/a/41069638
# https://stackoverflow.com/a/41652679

# catchout stdoutvar command args...
function catchout() {
	local catchout_tmpfile; catchout_tmpfile="$(mktemp)"; readonly catchout_tmpfile
	"${@:2}" >"$catchout_tmpfile"
	local -r ret="$?"
	eval "$1=\$("$CAT" -- \"$catchout_tmpfile\")"
	"$RM" -f -- "$catchout_tmpfile" || true
	return "$ret"
}
