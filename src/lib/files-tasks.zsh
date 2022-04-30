# Files and folders-related utilities

## Make sure the given folder exists with given permission.
## Usage: task__folder folder_name permission
## Example: task__folder /var/log 755
function task__folder() {
	local -r folder_name="$1" permission="$2"
	
	start_task "folder ${folder_name/#$HOME/\~}"
	catchout RES  libfiles__folder "$folder_name" "$permission"
	log_task_from_res "$RES"
}


## Make sure the given file is deleted. Fails if the path is a folder.
## Usage: task__delete_file path
## Example: task__delete_file "$HOME/.obsolete"
function task__delete_file() {
	local -r deleted_path="$1"
	
	start_task "delete file ${deleted_path/#$HOME/\~}"
	catchout RES   libfiles__delete_file "$deleted_path"
	log_task_from_res "$RES"
}
