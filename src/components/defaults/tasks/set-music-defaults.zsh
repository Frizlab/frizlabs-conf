# Setup some defaults for the Music app

start_task "set show status bar in Music"
catchout RES  libdefaults__set_bool com.apple.Music showStatusBar 1
log_task_from_res "$RES"
