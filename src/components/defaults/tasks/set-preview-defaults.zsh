# Setup some defaults for Preview
# TODO: Toolbar w/ zoom -=+ instead of -+ only.

start_task "set size unit to pixel in Preview"
catchout RES  libdefaults__set_int com.apple.Preview PVImageSizeSizeUnit 5
log_task_from_res "$RES"

start_task "set resolution unit to pixels/inch in Preview"
catchout RES  libdefaults__set_int com.apple.Preview PVImageSizeResolutionUnit 10
log_task_from_res "$RES"
