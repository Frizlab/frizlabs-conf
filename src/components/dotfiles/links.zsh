# Create links to files in this repo, with backup if needed

# First create the backup folder
start_task "dotfiles backup folder ${DOTFILES_BACKUP_DIR/#$HOME/\~}"
catchout res_folder folder "$DOTFILES_BACKUP_DIR" "$DOTFILES_BACKUP_DIR_MODE"
log_task_from_res "$res_folder"

res_check "$res_folder" && {
	for file in "${DOTFILE_FILES[@]}"; do
		dest_file="$HOME/$file"
		repo_file="$(pwd)/files/_$file"
		start_task "link _$file -> ${dest_file/#$HOME/\~}"
		catchout RES   linknbk "$repo_file" "$dest_file" "600" "$DOTFILES_BACKUP_DIR"
		log_task_from_res "$RES"
	done
} || true
