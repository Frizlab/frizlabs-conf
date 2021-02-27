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

start_task "install gcloud"
if test -n "$tar_url"; then
	RES=; RES_LIST=()
	{ res_check "$RES" &&   temp="$(mktemp)"   || { log_task_failure "cannot create temporary file"   && RES_LIST+=("failed") } }
	{ res_check "$RES" &&   catchout RES  folder "$GCLOUD_DIR" "755"                                  && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   test -x "$GCLOUD_DIR/bin/gcloud"                                          && RES_LIST+=("ok") } || {
		{ res_check "$RES" &&   curl -L "$tar_url" 2>/dev/null | tar xz --strip 1 -C "$GCLOUD_DIR" && RES_LIST+=("$RES") }
	}
	log_task_from_res_list RES_LIST
	
	start_task "add gcloud to PATH"
	# We purposefully _not_ use path.zsh.inc (or path.bash.inc) because we want gougle’s path to be *last*.
	catchout RES  detemplate "$(pwd)/templates/profile.sh.m4" "$HOME/.profile.d/590-gougle-cloud-sdk.sh" "600"
	log_task_from_res "$RES"
	
	start_task "install zsh completion"
	catchout RES  lnk "$GCLOUD_DIR/completion.zsh.inc"  "$HOME/.zshrc.d/590-gougle-cloud-sdk-completion.sh"  "600"
	log_task_from_res "$RES"
	start_task "install bash completion"
	catchout RES  lnk "$GCLOUD_DIR/completion.bash.inc" "$HOME/.bashrc.d/590-gougle-cloud-sdk-completion.sh" "600"
	log_task_from_res "$RES"
else
	log_task_failure "cannot install gcloud (unable to infer gcloud URL from platform/arch)"
fi
