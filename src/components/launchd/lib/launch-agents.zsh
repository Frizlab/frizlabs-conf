# Some doc:
#    https://babodee.wordpress.com/2016/04/09/launchctl-2-0-syntax/
#    https://ss64.com/osx/launchctl.html

## Usage: install_user_launch_agent label
## label should be of the reverse DNS form (e.g. me.frizlab.the-best-agent)
function task__install_user_launch_agent() {
	local -r label="$1"
	
	local -r AGENT_FOLDER_PATH="$HOME/Library/LaunchAgents"
	
	local local_template_path; local_template_path="$(pwd)/templates/$label.plist"; readonly local_template_path
	local -r agent_dest_path="$AGENT_FOLDER_PATH/$label.plist"
	
	RES=; RES_TPLT=; RES_LIST=()
	start_task "install user agent $label"
	{ res_check "$RES"      &&   catchout RES       libfiles__folder "$AGENT_FOLDER_PATH" "755"                          && RES_LIST+=("$RES")      }
	{ res_check "$RES"      &&   catchout RES_TPLT  libtemplates__detemplate "$local_template_path" "$agent_dest_path" "644" && RES_LIST+=("$RES_TPLT") }
	{ res_check "$RES_TPLT" &&   catchout RES       reload_user_launchd "$agent_dest_path" "$RES_TPLT"         && RES_LIST+=("$RES")      }
	log_task_from_res_list RES_LIST
}

## NOT intended to be used directly
## Usage: reload_user_launchd label plist_path plist_install_res
## label should be of the reverse DNS form (e.g. me.frizlab.the-best-agent)
function reload_user_launchd() {
	local -r plist_path="$1"
	local -r plist_install_res="$2"
	
	case "$plist_install_res" in
		"changed")
			# We do the thing later. Consider this switch case a guard.
		;;
		*)
			# In all cases but changed, we do nothing and say we’re ok.
			echo "ok"
			return
		;;
	esac
	
	# plist installation changed the plist, so we must reload.
	# We ignore bootout error as it is normal to get an error if plist was not loaded yet.
	# In theory we should check whether the plist was loaded, etc., but I don’t want to do it.
	run_and_log launchctl bootout   "gui/$USER_ID" "$plist_path" || true
	run_and_log launchctl bootstrap "gui/$USER_ID" "$plist_path" || { log_task_failure "cannot bootstrap $plist_path with domain gui/$USER_ID"; echo "failed"; return }
	echo "changed"
}
