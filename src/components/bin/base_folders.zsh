# Install base folders in which to install the binaries and their docs.

task__folder "$FIRST_PARTY_BIN_DIR" "755"
task__folder "$THIRD_PARTY_BIN_DIR" "755"

task__folder "$FIRST_PARTY_SBIN_DIR" "755"
task__folder "$THIRD_PARTY_SBIN_DIR" "755"

task__folder "$FIRST_PARTY_SHARE_DIR" "755"
task__folder "$THIRD_PARTY_SHARE_DIR" "755"
