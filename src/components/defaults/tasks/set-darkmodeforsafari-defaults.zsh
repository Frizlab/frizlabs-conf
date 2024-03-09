# Setup some defaults for Dark Mode for Safari

start_task "Dark Mode for Safari: set dark mode theme"
catchout RES  libdefaults__set_str "com.alexandrudenk.Dark-Mode-for-Safari.Extension" "THEME_KEY" "SofterDarkMode"
log_task_from_res "$RES"

start_task "Dark Mode for Safari: set to activate when system is in dark mode"
catchout RES  libdefaults__set_int "com.alexandrudenk.Dark-Mode-for-Safari.Extension" "ACTIVATION_KEY" 2
log_task_from_res "$RES"

start_task "Dark Mode for Safari: set filter mode to whitelist"
# 0 is blacklist (apply to all except…), 1 is whitelist (apply to none except…)
catchout RES  libdefaults__set_int "com.alexandrudenk.Dark-Mode-for-Safari.Extension" "SITE_FILTER_KEY" 0
log_task_from_res "$RES"

start_task "Dark Mode for Safari: set blacklist"
catchout RES  run_and_log_keep_stdout ./lib/set-dark-mode-for-safari-sites-list.swift "FORGET_" "${DEFAULTS__DARK_MODE_FOR_SAFARI_BLACKLISTED_SITES[@]}" || log_task_failure "error while running set-dark-mode-for-safari-sites-list (do you have Xcode installed?)"
log_task_from_res "$RES"

start_task "Dark Mode for Safari: set whitelist"
catchout RES  run_and_log_keep_stdout ./lib/set-dark-mode-for-safari-sites-list.swift "ONLY_" "${DEFAULTS__DARK_MODE_FOR_SAFARI_WHITELISTED_SITES[@]}" || log_task_failure "error while running set-dark-mode-for-safari-sites-list (do you have Xcode installed?)"
log_task_from_res "$RES"
