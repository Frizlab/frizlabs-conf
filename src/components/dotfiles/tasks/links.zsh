# Create links to files in this repo, with backup if needed.
for file in "${DOTFILES__FILES[@]}"; do
	dest_file="$HOME/$file"
	repo_file="$COMPONENT_ROOT_FOLDER/files/_$file"
	start_task "link _$file -> ${dest_file/#$HOME/\~}"
	catchout RES   libfiles__linknbk "$repo_file" "$dest_file" "600" "$DOTFILES__BACKUP_DIR" "$DOTFILES__BACKUP_DIR_MODE"
	log_task_from_res "$RES"
done
