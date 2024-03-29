# Setup some defaults for Preview
# TODO: Toolbar w/ zoom -=+ instead of -+ only.

start_task "Preview: set size unit to pixel"
catchout RES  libdefaults__set_int com.apple.Preview PVImageSizeSizeUnit 5
log_task_from_res "$RES"

start_task "Preview: set resolution unit to pixels/inch"
catchout RES  libdefaults__set_int com.apple.Preview PVImageSizeResolutionUnit 10
log_task_from_res "$RES"
