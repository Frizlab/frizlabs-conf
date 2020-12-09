## Usage: bin author compatibility relative_path_to_script
function bin() {
	author="$1"
	compatibility="$2"
	local_relative_script_path="$3"
	
	[[ "$compatibility" =~ ":$HOST_OS:" ]] || return
	
	me="$(whoami)"
	dest_bin_dir=""
	if test "$author" = "$me"; then dest_bin_dir="$FIRST_PARTY_BIN_DIR";
	else                            dest_bin_dir="$THIRD_PARTY_BIN_DIR"; fi
	
	backup_dir="$dest_bin_dir/$BIN_BACKUP_DIR_BASENAME"
	
	local_script_path="$(pwd)/files/$local_relative_script_path"
	script_basename="${local_relative_script_path##*/}"
	script_basename_no_ext="${script_basename%.*}"
	script_dest_path="$dest_bin_dir/$script_basename_no_ext"
	
	res=; res_list=()
	CURRENT_TASK_NAME="install $local_relative_script_path -> ${script_dest_path/#$HOME/\~}"
	{ res_check "$res" &&   catchout res  folder "$backup_dir" "$BIN_BACKUP_DIR_MODE"                            && res_list+=("$res") } || true
	{ res_check "$res" &&   catchout res  linknbk "$local_script_path" "$script_dest_path" "755" "$backup_dir"   && res_list+=("$res") } || true
	log_task_from_res_list res_list
}
