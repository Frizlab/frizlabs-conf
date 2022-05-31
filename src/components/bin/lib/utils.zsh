## Usage: bin__install_dest author 1st_party_folder 3rd_party_folder subfolder
function bin__install_dest() {
	local -r author="$1"; shift
	local -r dest_1st_party="$1"; shift
	local -r dest_3rd_party="$1"; shift
	local -r dest_subfolder="$1"; shift
	
	echo "$(get_author_val "$author" "$dest_1st_party" "$dest_3rd_party")${dest_subfolder:+/}$dest_subfolder"
}
## Usage: bin__install_name destname_method local_path
function bin__install_name() {
	local -r destname_method="$1"; shift
	local -r local_path="$1"; shift
	
	local -r basename="${local_path##*/}"
	case "$destname_method" in
		same)                      echo "$basename";;
		custom:*)                  echo "${destname_method#custom:}";;
		remove_ext)                echo "${basename%.*}";;
		remove_ext_from_encrypted) echo "${basename%.*.cpt}";;
		*) fatal "Unknown destname_method $destname_method"
	esac
}


## Usage: task__install author compatibility dest_1st_party dest_3rd_party dest_subfolder relative_path_to_install mode install_method destname_method [-cflags cflags]
##
## Notes:
## install_method can be one of:
##    - link
##    - copy
##    - decrypt
##    - compile-c
##    - wrap
## cflags is ignored if install_method is not compile-c or wrap
function bin_task__install() {
	local -r author="$1"; shift
	local -r compatibility="$1"; shift
	local -r dest_1st_party="$1"; shift
	local -r dest_3rd_party="$1"; shift
	local -r dest_subfolder="$1"; shift
	local -r local_relative_path="$1"; shift
	local -r mode="$1"; shift
	local -r install_method="$1"; shift
	local -r destname_method="$1"; shift
	
	local cflags=
	while [ $# -gt 0 ]; do
		case "$1" in
			-cflags)
				shift
				[ $# -gt 0 ] || fatal "Invalid call to task__install: no argument given to -cflags."
				cflags="$1"; shift
			;;
			*)
				fatal "Invalid call to task__install: unknown option $1."
			;;
		esac
	done
	readonly cflags
	
	local -r local_path="$COMPONENT_ROOT_FOLDER/files/$local_relative_path"
	
	local -r dest_folder="$(bin__install_dest "$author" "$dest_1st_party" "$dest_3rd_party" "$dest_subfolder" "$local_relative_path")"
	local -r backup_dir="$dest_folder/$BIN__BACKUP_DIR_BASENAME"
	
	local -r dest_name="$(bin__install_name "$destname_method" "$local_relative_path")"
	local -r dest_path="$dest_folder/$dest_name"
	
	if check_full_compatibility "$compatibility"; then
		case "$install_method" in
			link)
				start_task "install (link) ${dest_path/#$HOME/\~} (from $local_relative_path)"
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$dest_folder" "755"                                                        && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__linknbk "$local_path" "$dest_path" "$mode" "$backup_dir" "$BIN__BACKUP_DIR_MODE"   && RES_LIST+=("$RES") }
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
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$dest_folder" "755"                         && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__decrypt_and_copy "$local_path" "$dest_path" "755"   && RES_LIST+=("$RES") }
				log_task_from_res_list RES_LIST
			;;
			compile-c)
				start_task "install (compile c) ${dest_path/#$HOME/\~} (from $local_relative_path)"
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$dest_folder" "755"                     && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__compilec "$local_path" "$dest_path" "$cflags"   && RES_LIST+=("$RES") }
				log_task_from_res_list RES_LIST
			;;
			wrap)
				local script=
				local interpreter_args=
				start_task "install (wrap) ${dest_path/#$HOME/\~} (from $local_relative_path and c/exec-script.c)"
				{ res_check "$RES" &&   script="$(run_and_log_keep_stdout file_to_c_hex "$local_path")"                      || { log_task_failure "cannot convert script to hex.";  RES="failed"; RES_LIST+=("$RES") } }
				{ res_check "$RES" &&   interpreter_args="$(run_and_log_keep_stdout extract_interpreter_args "$local_path")" || { log_task_failure "cannot get script interpreter."; RES="failed"; RES_LIST+=("$RES") } }
				local compiled_file="$COMPONENT_ROOT_FOLDER/files/c/exec-script.c"
				local full_cflags="$cflags ${interpreter_args:+-DINTERPRETER_ARGS='}$interpreter_args${interpreter_args:+'} -DSCRIPT_PATH='$local_path' -DSCRIPT='$script'"
				{ res_check "$RES" &&   catchout RES  libfiles__folder "$dest_folder" "755"                                           && RES_LIST+=("$RES") }
				{ res_check "$RES" &&   catchout RES  libfiles__compilec "$compiled_file" "$dest_path" "$full_cflags" "$local_path"   && RES_LIST+=("$RES") }
				log_task_from_res "$RES"
			;;
		esac
	else
		task__delete_file "$dest_path"
	fi
}
