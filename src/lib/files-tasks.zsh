# Files and folders-related utilities

## Make sure the given folder exists with given permission
## Usage: folder folder_name permission
## Example: folder /var/log 755
function task__folder() {
	local -r folder_name="$1" permission="$2"
	
	start_task "folder ${folder_name/#$HOME/\~}"
	catchout RES  libfiles__folder "$folder_name" "$permission"
	log_task_from_res "$RES"
}
