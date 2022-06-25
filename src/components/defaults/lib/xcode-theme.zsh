##
## Usage: defaults_task__install_modified_xcode_theme builtin_xcode_theme_name dest_name transformation1 ...
## Example: defaults_task__install_modified_xcode_theme "Default (Light)" "Default + Frizlab (Light)" mono smaller
function defaults_task__install_modified_xcode_theme() {
	local -r xcode_theme="$1"; shift
	local -r dest_name="$1"; shift
	
	local -r src="../SharedFrameworks/DVTUserInterfaceKit.framework/Versions/A/Resources/FontAndColorThemes/$xcode_theme.xccolortheme"
	local -r dest_folder="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
	local -r dest="$dest_folder/$dest_name.xccolortheme"
	
	start_task "Xcode: install modified theme “$dest_name” from builtin “$xcode_theme” with transformations “$*”"
	
	# Let’s create the modified theme.
	local modified_theme
	modified_theme="$(run_and_log_keep_stdout ./lib/patch-xcode-theme.swift "$src" "$@")" || { log_task_failure "cannot create the modified theme"; return }
	readonly modified_theme
	
	{ res_check "$RES"  &&  catchout RES  libfiles__folder "$dest_folder" "755"                       && RES_LIST+=("$RES") }
	{ res_check "$RES"  &&  catchout RES  libfiles__copy_from_memory "$modified_theme" "$dest" "644"  && RES_LIST+=("$RES") }
	log_task_from_res_list RES_LIST
}
