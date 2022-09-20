# Setup some defaults for HIGTypography

start_task "HIGTypography: reset dynamic type to large on launch"
catchout RES  libdefaults__set_bool hr.ux-first.HIGTypography resetDTSAtLaunch 1
log_task_from_res "$RES"
