# Setup some defaults for Pixie

start_task "hide grid in Pixie"
catchout RES  libdefaults__set_bool com.apple.Pixie showGrid 0
log_task_from_res "$RES"

start_task "hide mouse coordinates in Pixie"
catchout RES  libdefaults__set_bool com.apple.Pixie showCoords 0
log_task_from_res "$RES"

start_task "set scale of grid to 16x in Pixie"
catchout RES  libdefaults__set_int com.apple.Pixie scale 16
log_task_from_res "$RES"

start_task "set color format in Pixie"
catchout RES  libdefaults__set_int com.apple.Pixie colorValueFormat 1
log_task_from_res "$RES"
