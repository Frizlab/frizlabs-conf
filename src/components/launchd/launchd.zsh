# Launch Agents vs Launch Daemons: https://apple.stackexchange.com/a/290946

source "./lib/launch-agents.zsh"

# TODO: Do not execute an sh script. It poses two problems:
#    - First, sh is not allowed to read in ~/Documents, so we have to copy the script someplace else.
#      But that’s workarounded, we have created LAUNCHD_CLT_BIN_DIR exactly for this;
#    - Secondly, and maybe more importantly, for this script to run, the executable running it must have access to Apple Events for Safari and System Events.
#      And thus we have to give access to /bin/sh to these events which might be dangerous (if we’re paranoid).
# TODO: Correctly manage output (currently each run is appended to output file).
install_user_launch_agent "me.frizlab.dump-safari-tabs"
