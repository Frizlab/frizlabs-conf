## Usage: bin author compatibility relative_path_to_script
## Compatibility format: ":compatible_host_os:~forbidden_computer_group~"
## Example: ":Darwin:Linux:~work~home~" is compatible with Darwin and Linux and must not be installed at work or home.
##          Will actually be _removed_ from work and home if already present, or on another OS than Darwin and Linux.
function bin_task__bin() {
	bin_task__install "$1" "$2" "$FIRST_PARTY_BIN_DIR" "$THIRD_PARTY_BIN_DIR" "" "$3" "755" "link" "remove_ext"
}

function bin_task__encrypted_bin() {
	bin_task__install "$1" "$2" "$FIRST_PARTY_BIN_DIR" "$THIRD_PARTY_BIN_DIR" "" "$3" "755" "decrypt" "remove_ext_from_encrypted"
}

# TODO: Fix the doc and do the function
# We do not install the script directly because it is launched through a custom-made launcher.
# We have to do this because the script uses AppleEvents and we do not want to whitelist `sh` for AppleEvents.
# See the Readme for more info about launchd and AppleEvents.
# We _copy_ the script instead of (soft-)linking it because otherwise
#  the launcher would need access to the Documents folder (if the conf repo is in Documents),
#  which is an otherwise unnecessary permission (and thus unwise to give if it can be avoided).
# Note: We could probably hard-link the file instead of copying it.
function bin_task__wrapped_bin() {
	# xxd -c0 -ps "$FILE" | sed -r 's/(..)/0x\1,/g;s/,$//'
	start_task "install a wrapped bin"
	log_task_failure "not implemented"
}

function bin_task__delete_bin() {
	local -r author="$1"
	local -r script_name="$2"
	
	task__delete_file "$(get_author_val "$author" "$FIRST_PARTY_BIN_DIR" "$THIRD_PARTY_BIN_DIR")/$script_name"
}
