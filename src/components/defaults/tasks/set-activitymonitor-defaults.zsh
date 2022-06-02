# Setup some defaults for Activity Monitor

start_task "set show all processes in Activity Monitor"
catchout RES  libdefaults__set_int com.apple.ActivityMonitor ShowCategory 100
log_task_from_res "$RES"

start_task "set update frequency in Activity Monitor"
catchout RES  libdefaults__set_int com.apple.ActivityMonitor UpdatePeriod 2
log_task_from_res "$RES"
