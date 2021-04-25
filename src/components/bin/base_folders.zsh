# Install base folders in which to install the binaries and their docs.


start_task "folder ${FIRST_PARTY_BIN_DIR/#$HOME/\~}"
catchout RES  folder "$FIRST_PARTY_BIN_DIR" "755"
log_task_from_res "$RES"

start_task "folder ${THIRD_PARTY_BIN_DIR/#$HOME/\~}"
catchout RES  folder "$THIRD_PARTY_BIN_DIR" "755"
log_task_from_res "$RES"


start_task "folder ${FIRST_PARTY_SHARE_DIR/#$HOME/\~}"
catchout RES  folder "$FIRST_PARTY_SHARE_DIR" "755"
log_task_from_res "$RES"

start_task "folder ${THIRD_PARTY_SHARE_DIR/#$HOME/\~}"
catchout RES  folder "$THIRD_PARTY_SHARE_DIR" "755"
log_task_from_res "$RES"


if [ "$HOST_OS" = "Darwin" ]; then
	start_task "folder ${LAUNCHD_CLT_BIN_DIR/#$HOME/\~}"
	catchout RES  folder "$LAUNCHD_CLT_BIN_DIR" "755"
	log_task_from_res "$RES"
fi
