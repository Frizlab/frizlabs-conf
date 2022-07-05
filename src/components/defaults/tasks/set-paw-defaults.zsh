# Setup some defaults for Paw

start_task "Paw: use URLSession for the network"
catchout RES  libdefaults__set_str com.luckymarmot.Paw LMUserDefaultHTTPLibrary URLConnection
log_task_from_res "$RES"
