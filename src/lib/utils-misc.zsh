## Usage: fatal [error_msg]
## Exits with code 255, optionally printing an error message before to stderr, in red.
function fatal() {
	if [ $# -gt 0 ]; then
		print -P "%F{red}%BFATAL ERROR%b: $*%f"
	else
		print -P "%F{red}%BFATAL ERROR%b%f"
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


## Usage: file_to_hex path
## Outputs the contents of the file converted to hex (like so '"\x48""\x65""\x6c""\x6c""\x6f""\x0a").
function file_to_c_hex() {
	xxd -c0 -ps "$1" | sed -r 's/(..)/"\\x\1"/g'
}


## Usage: extract_interpreter_args path
## Retrieve the shebang from a script in a format suitable for exec-script.c (e.g. '"/bin/sh","-ed",NULL').
## If there are no shebang found, an empty string is returned.
function extract_interpreter_args() {
	local -r script_path="$1"
	# Retrieve first line of the file.
	line="$(head -n"+1" "$script_path")" || return 1
	# If the first line do not start with #! we simply say we’re good and return an empty string.
	print "$line" | grep -qE '^#!' || return 0
	# We do a simple double-quote escaping and nothing else.
	printf '"' || return 1
	printf "%s" "$line" | sed -E 's/^#!//;s/"/\\"/g;s/ /","/g' || return 1
	printf '",NULL' || return 1
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
