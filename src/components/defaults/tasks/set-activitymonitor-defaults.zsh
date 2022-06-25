# Setup some defaults for Activity Monitor

start_task "Activity Monitor: set show all processes"
catchout RES  libdefaults__set_int com.apple.ActivityMonitor ShowCategory 100
log_task_from_res "$RES"

start_task "Activity Monitor: set update frequency"
catchout RES  libdefaults__set_int com.apple.ActivityMonitor UpdatePeriod 2
log_task_from_res "$RES"
