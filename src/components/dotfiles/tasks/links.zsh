# Create links to files in this repo, with backup if needed

# First create the backup folder.
# We need to store the result of this operation, so we do not use task__folder.
start_task "dotfiles backup folder ${DOTFILES__BACKUP_DIR/#$HOME/\~}"
catchout res_folder libfiles__folder "$DOTFILES__BACKUP_DIR" "$DOTFILES__BACKUP_DIR_MODE"
log_task_from_res "$res_folder"

res_check "$res_folder" && {
	# The backup folder was created successfully, we can create the links.
	for file in "${DOTFILES__FILES[@]}"; do
		dest_file="$HOME/$file"
		repo_file="$(pwd)/files/_$file"
		start_task "link _$file -> ${dest_file/#$HOME/\~}"
		catchout RES   libfiles__linknbk "$repo_file" "$dest_file" "600" "$DOTFILES__BACKUP_DIR"
		log_task_from_res "$RES"
	done
} || true
