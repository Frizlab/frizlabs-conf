# Setup some defaults for Dark Mode for Safari

start_task "Dark Mode for Safari: set dark mode theme"
catchout RES  libdefaults__set_str "com.alexandrudenk.Dark-Mode-for-Safari.Dark-Mode" "THEME_KEY" "SofterDarkMode"
log_task_from_res "$RES"

start_task "Dark Mode for Safari: set to activate when system is in dark mode"
catchout RES  libdefaults__set_int "com.alexandrudenk.Dark-Mode-for-Safari.Dark-Mode" "ACTIVATION_KEY" 2
log_task_from_res "$RES"

start_task "Dark Mode for Safari: set filter mode to ignore list"
catchout RES  libdefaults__set_int "com.alexandrudenk.Dark-Mode-for-Safari.Dark-Mode" "SITE_FILTER_KEY" 0
log_task_from_res "$RES"
