# Decrypts the encrypted files and put them at the correct location.
for file in "${DOTFILES__ENCRYPTED[@]}"; do
	dest_file="$HOME/$file"
	repo_file="$COMPONENT_ROOT_FOLDER/files/_$file.cpt"
	start_task "decrypt ${dest_file/#$HOME/\~}"
	catchout RES   libfiles__decrypt_and_copy "$repo_file" "$dest_file" "600" "$DOTFILES__BACKUP_DIR" "$DOTFILES__BACKUP_DIR_MODE"
	log_task_from_res "$RES"
done
