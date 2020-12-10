# Deal with macOS defaults

## Set an integer key for the given key using macOS defaults CLT.
## Usage: defaults_set_int domain key value
## Example: defaults_set_int NSGlobalDomain KeyRepeat 2
function defaults_set_int() {
	domain="$1"
	key="$2"
	value="$3"
	
	# Note: We do not handle the case where the key does not have the correct type
	current_value="$(defaults read "$domain" "$key" 2>/dev/null)" || { log_task_failure "cannot get current value for defaults domain $domain key $key"; echo "failed"; return }
	test "$current_value" != "$value" || { echo "ok"; return }
	
	defaults write "$domain" "$key" -int "$value" >/dev/null 2>&1 || { log_task_failure "cannot set value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}
