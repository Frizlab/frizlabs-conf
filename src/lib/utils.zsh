## Usage: fatal [error_msg]
## Exits with code 255, optionally printing an error message before to stderr, in red.
function fatal() {
	if [ $# -gt 0 ]; then
		print -P "%F{red}%BINTERNAL ERROR%b: $*%f"
	else
		print -P "%F{red}%BINTERNAL ERROR%b%f"
	fi
	exit 255
}


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


##
function highest_res_from_res_list() {
	local -r res_list_name="$1"
	
	local highest_res=
	for res in ${(P)${res_list_name}}; do
		case "$highest_res:$res" in
			:*)             highest_res="$res";;
			failed:*)       highest_res="failed";;
			changed:failed) highest_res="failed";;
			changed:*)      highest_res="changed";;
			ok:failed)      highest_res="failed";;
			ok:changed)     highest_res="changed";;
			*)              highest_res="ok";;
		esac
	done
	echo "$highest_res"
}


## Usage: get_author_val author_name user_is_author_value user_is_not_author_value
function get_author_val() {
	local -r author="$1"; shift
	local -r val_1st_party="$1"; shift
	local -r val_3rd_party="$1"; shift
	
	if test "$author" = "${USER:-$(whoami)}"; then echo "$val_1st_party";
	else                                           echo "$val_3rd_party"; fi
}


## Compatibility format: ":compatible_host_os:~forbidden_computer_group~"
##
## Example: ":Darwin:Linux:~work~home~" is compatible with Darwin and Linux and must not be installed at work or home.

##
function check_host_compatibility() {
	[[ "$1" =~ ":$HOST_OS:" ]]
}
##
function check_env_compatibility() {
	[[ ! "$1" =~ "~$COMPUTER_GROUP~" ]]
}
##
function check_full_compatibility() {
	check_host_compatibility "$1" && check_env_compatibility "$1"
}
