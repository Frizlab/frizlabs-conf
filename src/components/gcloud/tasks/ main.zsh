# Install the google cloud sdk and add its path to the PATH.
# TODO: Check checksum

# Update URLs from https://cloud.google.com/sdk/docs/install
tar_url=
tar_shasum=
case "$HOST_OS:$HOST_ARCH" in
	Darwin:x86_64)
		tar_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-383.0.1-darwin-x86_64.tar.gz"
		tar_shasum="f1899cbf58061f5ca97923565d7fc7a9729b0f65f9387b43330c00aef41252d1"
	;;
	Darwin:arm64)
		tar_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-383.0.1-darwin-arm.tar.gz"
		tar_shasum="6179311562f0397e8926ee5483b65daa926b64774ee0ce48cb993de298e98f97"
	;;
	Linux:x86_64)
		tar_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-383.0.1-linux-x86_64.tar.gz"
		tar_shasum="978cc2b7e3d58d680abd600bbdc96dca6eccd0d7ff11df15760e5321db8ce07d"
	;;
esac

start_task "install gcloud"
if test -n "$tar_url"; then
	RES=; RES_LIST=()
	{ res_check "$RES" &&   temp="$(run_and_log_keep_stdout mktemp)"   || { log_task_failure "cannot create temporary file" && RES_LIST+=("failed") } }
	{ res_check "$RES" &&   catchout RES  libfiles__folder "$GCLOUD_DIR" "755"                                              && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   run_and_log test -x "$GCLOUD_DIR/bin/gcloud"                                                    && RES_LIST+=("ok") } || {
		{ res_check "$RES" &&   curl -sL "$tar_url" | run_and_log "$TAR" xz --strip 1 -C "$GCLOUD_DIR" && RES_LIST+=("ok") || { log_task_failure "cannot download or extract gcloud" && RES_LIST+=("failed") } }
	}
	log_task_from_res_list RES_LIST
	
	start_task "add gcloud to PATH"
	# We purposefully _not_ use path.zsh.inc (or path.bash.inc) because we want gougle’s path to be *last*.
	catchout RES  libtemplates__detemplate "$(pwd)/templates/profile.sh.m4" "$HOME/.profile.d/590-gougle-cloud-sdk.sh" "600"
	log_task_from_res "$RES"
	
	start_task "install zsh completion"
	catchout RES  libfiles__lnk "$GCLOUD_DIR/completion.zsh.inc"  "$HOME/.zshrc.d/590-gougle-cloud-sdk-completion.sh"  "600"
	log_task_from_res "$RES"
	start_task "install bash completion"
	catchout RES  libfiles__lnk "$GCLOUD_DIR/completion.bash.inc" "$HOME/.bashrc.d/590-gougle-cloud-sdk-completion.sh" "600"
	log_task_from_res "$RES"
else
	log_task_failure "cannot install gcloud (unable to infer gcloud URL from platform/arch)"
fi
