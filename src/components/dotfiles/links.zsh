# Create links to files in this repo, with backup if needed

# First create the backup folder
CURRENT_TASK_NAME="create backup folder for dotfiles at $DOTFILES_BACKUP_DIR"
res_folder="$(folder "$DOTFILES_BACKUP_DIR" "$DOTFILES_BACKUP_DIR_MODE")"
log_task_from_res "$res_folder"

res_check "$res_folder" && {
	for file in $DOTFILE_FILES; do
		dest_file="$HOME/$file"
		repo_file="$(pwd)/files/_$file"
		CURRENT_TASK_NAME="link $file"
		res="$(linknbk "$repo_file" "$dest_file" "$DOTFILES_BACKUP_DIR")"
		log_task_from_res "$res"
	done
}
