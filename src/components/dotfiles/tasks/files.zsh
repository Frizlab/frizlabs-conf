# Create links to files in this repo, with backup if needed.
for file in "${DOTFILES__FILES[@]}"; do
	dest_file="$HOME/$file"
	repo_file="$COMPONENT_ROOT_FOLDER/files/_$file"
	start_task "link _$file -> ${dest_file/#$HOME/\~}"
	catchout RES   libfiles__linknbk "$repo_file" "$dest_file" "600" "$DOTFILES__BACKUP_DIR" "$DOTFILES__BACKUP_DIR_MODE"
	log_task_from_res "$RES"
done

# Detemplatize the templates and put them at the correct location.
for template in "${DOTFILES__TEMPLATES[@]}"; do
	dest_file="$HOME/$template"
	repo_file="$COMPONENT_ROOT_FOLDER/templates/_$template.m4"
	start_task "template ${dest_file/#$HOME/\~}"
	catchout RES   libtemplates__detemplate "$repo_file" "$dest_file" "600"
	log_task_from_res "$RES"
done

# Decrypt the encrypted files and put them at the correct location.
for file in "${DOTFILES__ENCRYPTED[@]}"; do
	dest_file="$HOME/$file"
	repo_file="$COMPONENT_ROOT_FOLDER/files/_$file.cpt"
	start_task "encrypted file ${dest_file/#$HOME/\~}"
	catchout RES   libfiles__decrypt_and_copy "$repo_file" "$dest_file" "600" "$DOTFILES__BACKUP_DIR" "$DOTFILES__BACKUP_DIR_MODE"
	log_task_from_res "$RES"
done

# Decrypt and detemplatize the encrypted templates and put them at the correct location.
for file in "${DOTFILES__ENCRYPTED_TEMPLATES[@]}"; do
	dest_file="$HOME/$file"
	repo_file="$COMPONENT_ROOT_FOLDER/templates/_$file.cpt"
	start_task "encrypted template ${dest_file/#$HOME/\~}"
	catchout RES   libtemplates__decrypt_and_detemplate "$repo_file" "$dest_file" "600" "$DOTFILES__BACKUP_DIR" "$DOTFILES__BACKUP_DIR_MODE"
	log_task_from_res "$RES"
done
