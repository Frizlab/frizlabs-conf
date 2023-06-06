# Setup some defaults for the Window Manager

start_task "Window Manager: disallow showing the desktop on standard click"
catchout RES  libdefaults__set_bool com.apple.WindowManager EnableStandardClickToShowDesktop 0
log_task_from_res "$RES"
