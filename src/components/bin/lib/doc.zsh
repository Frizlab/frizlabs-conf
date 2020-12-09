## Usage: doc author compatibility relative_path_to_folder relative_path_to_doc
function doc() {
	author="$1"
	compatibility="$2"
	relative_path_to_folder="$3"
	local_relative_doc_path="$4"
	
	[[ "$compatibility" =~ ":$HOST_OS:" ]] || return
	
	me="$(whoami)"
	dest_share_dir=""
	if test "$author" = "$me"; then dest_share_dir="$FIRST_PARTY_SHARE_DIR";
	else                            dest_share_dir="$THIRD_PARTY_SHARE_DIR"; fi
	
	dest_doc_dir="$dest_share_dir/$relative_path_to_folder"
	backup_dir="$dest_doc_dir/$BIN_BACKUP_DIR_BASENAME"
	
	local_doc_path="$(pwd)/files/$local_relative_doc_path"
	doc_basename="${local_relative_doc_path##*/}"
	doc_dest_path="$dest_doc_dir/$doc_basename"
	
	res=; res_list=()
	CURRENT_TASK_NAME="install $local_relative_doc_path -> ${doc_dest_path/#$HOME/\~}"
	{ res_check "$res" &&   catchout res  folder "$dest_doc_dir" "755"                                     && res_list+=("$res") } || true
	{ res_check "$res" &&   catchout res  folder "$backup_dir"   "$BIN_BACKUP_DIR_MODE"                    && res_list+=("$res") } || true
	{ res_check "$res" &&   catchout res  linknbk "$local_doc_path" "$doc_dest_path" "644" "$backup_dir"   && res_list+=("$res") } || true
	log_task_from_res_list res_list
}
