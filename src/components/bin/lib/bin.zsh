## Usage: bin author compatibility relative_path_to_script
## Compatibility format: ":compatible_host_os:~forbidden_computer_group~"
## Example: ":Darwin:Linux:~work~home~" is compatible with Darwin and Linux and
##          must not be installed at work or home. Will actually be _removed_
##          from work and home if already present, or on another OS than Darwin
##          and Linux. (Note we currently don’t have other groups than work and
##          home, so the example will never be installed.)
function bin() {
	author="$1"
	compatibility="$2"
	local_relative_script_path="$3"
	
	script_basename="${local_relative_script_path##*/}"
	script_basename_no_ext="${script_basename%.*}"
	
	{ [[ "$compatibility" =~ ":$HOST_OS:" ]] && [[ ! "$compatibility" =~ "~$COMPUTER_GROUP~" ]] } || {
		delete_bin "$author" "$script_basename_no_ext"
		return
	}
	
	me="$(whoami)"
	dest_bin_dir=""
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	
	backup_dir="$dest_bin_dir/$BIN_BACKUP_DIR_BASENAME"
	
	local_script_path="$(pwd)/files/$local_relative_script_path"
	script_dest_path="$dest_bin_dir/$script_basename_no_ext"
	
	res=; res_list=()
	CURRENT_TASK_NAME="install ${script_dest_path/#$HOME/\~} (from $local_relative_script_path)"
	{ res_check "$res" &&   catchout res  folder "$backup_dir" "$BIN_BACKUP_DIR_MODE"                            && res_list+=("$res") }
	{ res_check "$res" &&   catchout res  linknbk "$local_script_path" "$script_dest_path" "755" "$backup_dir"   && res_list+=("$res") }
	log_task_from_res_list res_list
}

function encrypted_bin() {
	author="$1"
	compatibility="$2"
	local_relative_script_path="$3"
	
	script_basename="${local_relative_script_path##*/}"
	script_basename_no_ext="${script_basename%.*.cpt}"
	
	{ [[ "$compatibility" =~ ":$HOST_OS:" ]] && [[ ! "$compatibility" =~ "~$COMPUTER_GROUP~" ]] } || {
		delete_bin "$author" "$script_basename_no_ext"
		return
	}
	
	me="$(whoami)"
	dest_bin_dir=""
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	
	local_script_path="$(pwd)/files/$local_relative_script_path"
	script_dest_path="$dest_bin_dir/$script_basename_no_ext"
	
	CURRENT_TASK_NAME="decrypt and install ${script_dest_path/#$HOME/\~}"
	catchout res   decrypt_and_copy "$local_script_path" "$script_dest_path" "755"
	log_task_from_res "$res"
}

function delete_bin() {
	author="$1"
	script_name="$2"
	
	me="$(whoami)"
	dest_bin_dir=""
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	deleted_path="$dest_bin_dir/$script_name"
	
	CURRENT_TASK_NAME="delete bin ${deleted_path/#$HOME/\~}"
	catchout res   delete "$deleted_path"
	log_task_from_res "$res"
}
