## Usage: bin author compatibility relative_path_to_script
## Compatibility format: ":compatible_host_os:~forbidden_computer_group~"
## Example: ":Darwin:Linux:~work~home~" is compatible with Darwin and Linux and
##          must not be installed at work or home. Will actually be _removed_
##          from work and home if already present, or on another OS than Darwin
##          and Linux. (Note we currently don’t have other groups than work and
##          home, so the example will never be installed.)
function bin() {
	local -r author="$1"
	local -r compatibility="$2"
	local -r local_relative_script_path="$3"
	
	local -r script_basename="${local_relative_script_path##*/}"
	local -r script_basename_no_ext="${script_basename%.*}"
	
	{ [[ "$compatibility" =~ ":$HOST_OS:" ]] && [[ ! "$compatibility" =~ "~$COMPUTER_GROUP~" ]] } || {
		delete_bin "$author" "$script_basename_no_ext"
		return
	}
	
	local dest_bin_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	readonly dest_bin_dir
	
	local -r backup_dir="$dest_bin_dir/$BIN_BACKUP_DIR_BASENAME"
	
	local local_script_path; local_script_path="$(pwd)/files/$local_relative_script_path"; readonly local_script_path
	local -r script_dest_path="$dest_bin_dir/$script_basename_no_ext"
	
	res=; res_list=()
	CURRENT_TASK_NAME="install ${script_dest_path/#$HOME/\~} (from $local_relative_script_path)"
	{ res_check "$res" &&   catchout res  folder "$backup_dir" "$BIN_BACKUP_DIR_MODE"                            && res_list+=("$res") }
	{ res_check "$res" &&   catchout res  linknbk "$local_script_path" "$script_dest_path" "755" "$backup_dir"   && res_list+=("$res") }
	log_task_from_res_list res_list
}

function encrypted_bin() {
	local -r author="$1"
	local -r compatibility="$2"
	local -r local_relative_script_path="$3"
	
	local -r script_basename="${local_relative_script_path##*/}"
	local -r script_basename_no_ext="${script_basename%.*.cpt}"
	
	{ [[ "$compatibility" =~ ":$HOST_OS:" ]] && [[ ! "$compatibility" =~ "~$COMPUTER_GROUP~" ]] } || {
		delete_bin "$author" "$script_basename_no_ext"
		return
	}
	
	local dest_bin_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	readonly dest_bin_dir
	
	local local_script_path; local_script_path="$(pwd)/files/$local_relative_script_path"; readonly local_script_path
	local -r script_dest_path="$dest_bin_dir/$script_basename_no_ext"
	
	CURRENT_TASK_NAME="decrypt and install ${script_dest_path/#$HOME/\~}"
	catchout res   decrypt_and_copy "$local_script_path" "$script_dest_path" "755"
	log_task_from_res "$res"
}

function delete_bin() {
	local -r author="$1"
	local -r script_name="$2"
	
	local dest_bin_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	readonly deleted_path="$dest_bin_dir/$script_name"
	
	CURRENT_TASK_NAME="delete bin ${deleted_path/#$HOME/\~}"
	catchout res   delete "$deleted_path"
	log_task_from_res "$res"
}
