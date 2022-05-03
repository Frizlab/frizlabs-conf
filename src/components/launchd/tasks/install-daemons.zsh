source "./lib/launch-agents.zsh"

# Launch Agents vs Launch Daemons: https://apple.stackexchange.com/a/290946

# TODO: Correctly manage output (currently each run is appended to output file).
launchd_task__install_user_launch_agent "me.frizlab.dump-safari-tabs"
