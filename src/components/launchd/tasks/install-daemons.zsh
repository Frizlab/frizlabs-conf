# Install dump-safari-tabs agent.
# TODO: Correctly manage output (currently each run is appended to output file).
task__folder "$LAUNCHD__DUMP_SAFARI_TABS_LOGS_DIR" "755"
launchd_task__install_user_launch_agent "me.frizlab.dump-safari-tabs"
