# Create the folders the different dotfiles expect (extension points)
for folder in "${DOTFILE_FOLDERS[@]}"; do
	start_task "folder ~/$folder"
	catchout RES   folder "$HOME/$folder" "700"
	log_task_from_res "$RES"
done
