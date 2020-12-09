# This is the question and the complicated answers to do this.
# TL;DR: Catching output of command w/ command being able to modify variables is
# almost impossible without temp files using bash/zsh.
# https://stackoverflow.com/q/11027679
# https://stackoverflow.com/a/41069638
# https://stackoverflow.com/a/41652679

# catchout stdoutvar command args...
function catchout() {
	tmpfile="$(mktemp)"
	"${@:2}" >"$tmpfile"
	ret=$?
	eval "$1=\$(cat \"$tmpfile\")"
	rm -f "$tmpfile"
	return $ret
}
