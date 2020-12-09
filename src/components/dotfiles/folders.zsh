# Create the folders the different dotfiles expect (extension points)
for folder in $DOTFILE_FOLDERS; do
	CURRENT_TASK_NAME="folder $folder"
	res_list=("$(folder "$HOME/$folder" "700")")
	log_task_from_res_list res_list
done
