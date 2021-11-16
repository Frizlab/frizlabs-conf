## Usage: bin author compatibility relative_path_to_script
## Compatibility format: ":compatible_host_os:~forbidden_computer_group~"
## Example: ":Darwin:Linux:~work~home~" is compatible with Darwin and Linux and must not be installed at work or home.
##          Will actually be _removed_ from work and home if already present, or on another OS than Darwin and Linux.
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
	
	RES=; RES_LIST=()
	start_task "install ${script_dest_path/#$HOME/\~} (from $local_relative_script_path)"
	{ res_check "$RES" &&   catchout RES  folder "$backup_dir" "$BIN_BACKUP_DIR_MODE"                            && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES  linknbk "$local_script_path" "$script_dest_path" "755" "$backup_dir"   && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
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
	
	start_task "decrypt and install ${script_dest_path/#$HOME/\~}"
	catchout RES   decrypt_and_copy "$local_script_path" "$script_dest_path" "755"
	log_task_from_res "$RES"
}

## Usage: launchd_bin compatibility relative_path_to_script
## Compatibility format: Same as for the bin function, but only computer group excludes are considered.
function launchd_bin() {
	local -r compatibility="$1"
	local -r local_relative_script_path="$2"
	
	local -r script_basename="${local_relative_script_path##*/}"
	local -r script_basename_no_ext="${script_basename%.*}"
	
	if [ "$HOST_OS" != "Darwin" ]; then
		return
	fi
	
	[[ ! "$compatibility" =~ "~$COMPUTER_GROUP~" ]] || {
		delete_launchd_bin "$script_basename_no_ext"
		return
	}
	
	local local_script_path; local_script_path="$(pwd)/files/$local_relative_script_path"; readonly local_script_path
	local -r script_dest_path="$LAUNCHD_CLT_BIN_DIR/$script_basename_no_ext"
	
	RES=; RES_LIST=()
	start_task "install ${script_dest_path/#$HOME/\~} (from $local_relative_script_path)"
	{ res_check "$RES" &&   catchout RES  copy "$local_script_path" "$script_dest_path" "755"   && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
}

function delete_bin() {
	local -r author="$1"
	local -r script_name="$2"
	
	local dest_bin_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	readonly deleted_path="$dest_bin_dir/$script_name"
	
	start_task "delete bin ${deleted_path/#$HOME/\~}"
	catchout RES   delete "$deleted_path"
	log_task_from_res "$RES"
}

function delete_launchd_bin() {
	local -r script_name="$1"
	
	readonly deleted_path="$LAUNCHD_CLT_BIN_DIR/$script_name"
	start_task "delete bin ${deleted_path/#$HOME/\~}"
	catchout RES   delete "$deleted_path"
	log_task_from_res "$RES"
}
