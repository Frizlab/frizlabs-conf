## Usage: doc author compatibility relative_path_to_folder relative_path_to_doc
function doc() {
	local -r author="$1"
	local -r compatibility="$2"
	local -r relative_path_to_folder="$3"
	local -r local_relative_doc_path="$4"
	
	local -r doc_basename="${local_relative_doc_path##*/}"
	
	{ [[ "$compatibility" =~ ":$HOST_OS:" ]] && [[ ! "$compatibility" =~ "~$COMPUTER_GROUP~" ]] } || {
		delete_doc "$author" "$relative_path_to_folder/$doc_basename"
		return
	}
	
	local dest_share_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_share_dir="$FIRST_PARTY_SHARE_DIR";
	else                            dest_share_dir="$THIRD_PARTY_SHARE_DIR"; fi
	readonly dest_share_dir
	
	local -r dest_doc_dir="$dest_share_dir/$relative_path_to_folder"
	local -r backup_dir="$dest_doc_dir/$BIN_BACKUP_DIR_BASENAME"
	
	local local_doc_path; local_doc_path="$(pwd)/files/$local_relative_doc_path"; readonly local_doc_path
	local -r doc_dest_path="$dest_doc_dir/$doc_basename"
	
	RES=; RES_LIST=()
	CURRENT_TASK_NAME="install ${doc_dest_path/#$HOME/\~} (from $local_relative_doc_path)"
	{ res_check "$RES" &&   catchout RES  folder "$dest_doc_dir" "755"                                     && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES  folder "$backup_dir"   "$BIN_BACKUP_DIR_MODE"                    && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES  linknbk "$local_doc_path" "$doc_dest_path" "644" "$backup_dir"   && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
}

function delete_doc() {
	local -r author="$1"
	local -r doc_name="$2"
	
	local dest_share_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_share_dir="$FIRST_PARTY_SHARE_DIR";
	else                            dest_share_dir="$THIRD_PARTY_SHARE_DIR"; fi
	readonly dest_share_dir
	local -r deleted_path="$dest_share_dir/$doc_name"
	
	CURRENT_TASK_NAME="delete doc ${deleted_path/#$HOME/\~}"
	catchout RES   delete "$deleted_path"
	log_task_from_res "$RES"
}
