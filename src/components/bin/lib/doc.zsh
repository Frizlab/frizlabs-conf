## Usage: doc author compatibility relative_path_to_folder relative_path_to_doc
function task__doc() {
## Usage: task__install author compatibility dest_1st_party dest_3rd_party dest_subfolder relative_path_to_install mode install_method
	task__install "$1" "$2" "$FIRST_PARTY_SHARE_DIR" "$THIRD_PARTY_SHARE_DIR" "$3" "$4" "644" "link" "same"
}

function task__delete_doc() {
	local -r author="$1"
	local -r doc_name="$2"
	
	local dest_share_dir=""
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then dest_share_dir="$FIRST_PARTY_SHARE_DIR";
	else                            dest_share_dir="$THIRD_PARTY_SHARE_DIR"; fi
	readonly dest_share_dir
	local -r deleted_path="$dest_share_dir/$doc_name"
	
	task__delete_file "$deleted_path"
}
