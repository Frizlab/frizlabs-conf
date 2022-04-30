## Usage: doc author compatibility relative_path_to_folder relative_path_to_doc
function task__doc() {
## Usage: task__install author compatibility dest_1st_party dest_3rd_party dest_subfolder relative_path_to_install mode install_method
	task__install "$1" "$2" "$FIRST_PARTY_SHARE_DIR" "$THIRD_PARTY_SHARE_DIR" "$3" "$4" "644" "link" "same"
}

function task__delete_doc() {
	local -r author="$1"
	local -r doc_name="$2"
	
	task__delete_file "$(get_author_val "$author" "$FIRST_PARTY_SHARE_DIR" "$THIRD_PARTY_SHARE_DIR")/$doc_name"
}
