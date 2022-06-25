# Setup some defaults for Pixie

start_task "Pixie: hide grid"
catchout RES  libdefaults__set_bool com.apple.Pixie showGrid 0
log_task_from_res "$RES"

start_task "Pixie: hide mouse coordinates"
catchout RES  libdefaults__set_bool com.apple.Pixie showCoords 0
log_task_from_res "$RES"

start_task "Pixie: set scale of grid to 16x"
catchout RES  libdefaults__set_int com.apple.Pixie scale 16
log_task_from_res "$RES"

start_task "Pixie: set color format"
catchout RES  libdefaults__set_int com.apple.Pixie colorValueFormat 1
log_task_from_res "$RES"
