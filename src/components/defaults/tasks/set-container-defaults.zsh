# Setup some defaults for container (Apple’s “docker”)


start_task "container: disable Rosetta"
catchout RES  libdefaults__set_bool com.apple.container.defaults build.rosetta 0
log_task_from_res "$RES"
