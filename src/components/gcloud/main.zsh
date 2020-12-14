# Install the google cloud sdk and add its path to the PATH

tar_url=
case "$HOST_OS:$HOST_ARCH" in
	Darwin:*)
		# Note: We ignore 32-bits macOS (it does not exist anymore)
		tar_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-320.0.0-darwin-x86_64.tar.gz"
	;;
	Linux:x86)
		tar_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-320.0.0-linux-x86_64.tar.gz"
	;;
esac

CURRENT_TASK_NAME="install gcloud"
if test -n "$tar_url"; then
	res=; res_list=()
	{ res_check "$res" &&   temp="$(mktemp)"   || { log_task_failure "cannot create temporary file"   && res_list+=("failed") } }
	{ res_check "$res" &&   catchout res  folder "$GCLOUD_DIR" "755"                                  && res_list+=("$res") }
	{ res_check "$res" &&   test -x "$GCLOUD_DIR/bin/gcloud"                                          && res_list+=("ok") } || {
		{ res_check "$res" &&   curl -L "$tar_url" 2>/dev/null | tar xz --strip 1 -C "$GCLOUD_DIR" && res_list+=("$res") }
	}
	log_task_from_res_list res_list
	
	CURRENT_TASK_NAME="add gcloud to PATH"
	# We purposefully _not_ use path.zsh.inc (or path.bash.inc) because we want gougle’s path to be *last*.
	catchout res  detemplate "$(pwd)/templates/profile.sh.m4" "$HOME/.profile.d/590-gougle-cloud-sdk.sh" "600"
	log_task_from_res "$res"
	
	CURRENT_TASK_NAME="install zsh completion"
	catchout res  lnk "$GCLOUD_DIR/completion.zsh.inc"  "$HOME/.zshrc.d/590-gougle-cloud-sdk-completion.sh"  "600"
	log_task_from_res "$res"
	CURRENT_TASK_NAME="install bash completion"
	catchout res  lnk "$GCLOUD_DIR/completion.bash.inc" "$HOME/.bashrc.d/590-gougle-cloud-sdk-completion.sh" "600"
	log_task_from_res "$res"
else
	log_task_failure "cannot install gcloud (unable to infer gcloud URL from platform/arch)"
fi
