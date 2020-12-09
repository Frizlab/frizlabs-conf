# Install base folders in which to install the binaries and their docs.


CURRENT_TASK_NAME="folder $FIRST_PARTY_BIN_DIR"
catchout res   folder "$FIRST_PARTY_BIN_DIR" "755"
log_task_from_res "$res"

CURRENT_TASK_NAME="folder $THIRD_PARTY_BIN_DIR"
catchout res   folder "$THIRD_PARTY_BIN_DIR" "755"
log_task_from_res "$res"


CURRENT_TASK_NAME="folder $FIRST_PARTY_SHARE_DIR"
catchout res   folder "$FIRST_PARTY_SHARE_DIR" "755"
log_task_from_res "$res"

CURRENT_TASK_NAME="folder $THIRD_PARTY_SHARE_DIR"
catchout res   folder "$THIRD_PARTY_SHARE_DIR" "755"
log_task_from_res "$res"
