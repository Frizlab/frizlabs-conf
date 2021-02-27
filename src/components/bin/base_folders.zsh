# Install base folders in which to install the binaries and their docs.


CURRENT_TASK_NAME="folder ${FIRST_PARTY_BIN_DIR/#$HOME/\~}"
catchout RES  folder "$FIRST_PARTY_BIN_DIR" "755"
log_task_from_res "$RES"

CURRENT_TASK_NAME="folder ${THIRD_PARTY_BIN_DIR/#$HOME/\~}"
catchout RES  folder "$THIRD_PARTY_BIN_DIR" "755"
log_task_from_res "$RES"


CURRENT_TASK_NAME="folder ${FIRST_PARTY_SHARE_DIR/#$HOME/\~}"
catchout RES  folder "$FIRST_PARTY_SHARE_DIR" "755"
log_task_from_res "$RES"

CURRENT_TASK_NAME="folder ${THIRD_PARTY_SHARE_DIR/#$HOME/\~}"
catchout RES  folder "$THIRD_PARTY_SHARE_DIR" "755"
log_task_from_res "$RES"
