## Usage: install_dest author 1st_party_folder 3rd_party_folder subfolder
function install_dest() {
	local -r author="$1"; shift
	local -r dest_1st_party="$1"; shift
	local -r dest_3rd_party="$1"; shift
	local -r dest_subfolder="$1"; shift
	
	local me; me="$(whoami)"; readonly me
	if test "$author" = "$me"; then echo "$dest_1st_party${dest_subfolder:+/}$dest_subfolder";
	else                            echo "$dest_3rd_party${dest_subfolder:+/}$dest_subfolder"; fi
}
## Usage: install_dest destname_method local_path
function install_name() {
	local -r destname_method="$1"; shift
	local -r local_path="$1"; shift
	
	local -r basename="${local_path##*/}"
	case "$destname_method" in
		same)                      echo "$basename";;
		remove_ext)                echo "${basename%.*}";;
		remove_ext_from_encrypted) echo "${basename%.*.cpt}";;
		*) fatal "Unknown destname_method $destname_method"
	esac
}


## Usage: task__install author compatibility dest_1st_party dest_3rd_party dest_subfolder relative_path_to_install mode install_method destname_method
function task__install() {
	local -r author="$1"; shift
	local -r compatibility="$1"; shift
	local -r dest_1st_party="$1"; shift
	local -r dest_3rd_party="$1"; shift
	local -r dest_subfolder="$1"; shift
	local -r local_relative_path="$1"; shift
	local -r mode="$1"; shift
	local -r install_method="$1"; shift
	local -r destname_method="$1"; shift
	
	local local_path; local_path="$(pwd)/files/$local_relative_path"; readonly local_path
	
	local -r dest_folder="$(install_dest "$author" "$dest_1st_party" "$dest_3rd_party" "$dest_subfolder" "$local_relative_path")"
	local -r backup_dir="$dest_folder/$BACKUP_DIR_BASENAME"
	
	local -r dest_name="$(install_name "$destname_method" "$local_relative_path")"
	local -r dest_path="$dest_folder/$dest_name"
	
	if check_full_compatibility "$compatibility"; then
		case "$install_method" in
			link)
				start_task "install (link) ${dest_path/#$HOME/\~} (from $local_relative_path)"
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$dest_folder" "755"                                && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$backup_dir"   "$BIN_BACKUP_DIR_MODE"              && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__linknbk "$local_path" "$dest_path" "$mode" "$backup_dir"   && RES_LIST+=("$RES") }
				log_task_from_res_list RES_LIST
			;;
			copy)
				start_task "install (copy) ${dest_path/#$HOME/\~} (from $local_relative_path)"
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$dest_folder" "755"                             && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__copy "$local_path" "$dest_path" "$mode" "$backup_dir"   && RES_LIST+=("$RES") }
				log_task_from_res_list RES_LIST
			;;
			decrypt)
				start_task "install (decrypt and copy) ${dest_path/#$HOME/\~} (from $local_relative_path)"
				catchout RES   libfiles__decrypt_and_copy "$local_path" "$dest_path" "755"
				log_task_from_res "$RES"
			;;
		esac
	else
		task__delete_file "$dest_path"
	fi
}