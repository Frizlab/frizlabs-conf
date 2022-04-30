# Launch Agents vs Launch Daemons: https://apple.stackexchange.com/a/290946

source "./lib/launch-agents.zsh"

# TODO: Correctly manage output (currently each run is appended to output file).
task__install_user_launch_agent "me.frizlab.dump-safari-tabs"
