## Usage: task__doc author compatibility relative_install_path relative_path_to_doc
function bin_task__doc() {
	bin_task__install "$1" "$2" "$FIRST_PARTY_SHARE_DIR" "$THIRD_PARTY_SHARE_DIR" "$3" "$4" "644" "link" "same"
}

function bin_task__delete_doc() {
	local -r author="$1"
	local -r doc_name="$2"
	
	task__delete_file "$(get_author_val "$author" "$FIRST_PARTY_SHARE_DIR" "$THIRD_PARTY_SHARE_DIR")/$doc_name"
}
