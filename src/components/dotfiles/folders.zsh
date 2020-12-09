# Create the folders the different dotfiles expect (extension points)
for folder in $DOTFILE_FOLDERS; do
	CURRENT_TASK_NAME="folder $folder"
	catchout res   folder "$HOME/$folder" "700"
	log_task_from_res "$res"
done
