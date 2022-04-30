## Usage: bin author compatibility relative_path_to_script
## Compatibility format: ":compatible_host_os:~forbidden_computer_group~"
## Example: ":Darwin:Linux:~work~home~" is compatible with Darwin and Linux and must not be installed at work or home.
##          Will actually be _removed_ from work and home if already present, or on another OS than Darwin and Linux.
function task__bin() {
	task__install "$1" "$2" "$FIRST_PARTY_BIN_DIR" "$THIRD_PARTY_BIN_DIR" "" "$3" "755" "link" "remove_ext"
}

function task__encrypted_bin() {
	task__install "$1" "$2" "$FIRST_PARTY_BIN_DIR" "$THIRD_PARTY_BIN_DIR" "" "$3" "755" "decrypt" "remove_ext_from_encrypted"
}

## Usage: launchd_bin compatibility relative_path_to_script
## Compatibility format: Same as for the bin function WITHOUT the host check (this is only useful on Darwin AFAIK).
function task__launchd_bin() {
	task__install "" ":Darwin:$1" "$LAUNCHD_CLT_BIN_DIR" "$LAUNCHD_CLT_BIN_DIR" "" "$2" "755" "copy" "remove_ext"
}

function task__delete_bin() {
	local -r author="$1"
	local -r script_name="$2"
	
	task__delete_file "$(get_author_val "$author" "$FIRST_PARTY_BIN_DIR" "$THIRD_PARTY_BIN_DIR")/$script_name"
}

function task__delete_launchd_bin() {
	local -r script_name="$1"
	
	task__delete_file "$LAUNCHD_CLT_BIN_DIR/$script_name"
}
