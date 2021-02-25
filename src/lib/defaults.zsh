# Deal with macOS defaults

## Set a string value for the given key using macOS defaults CLT.
## Usage: defaults_set_str [-currentHost] domain key value
## Example: defaults_set_str com.apple.Safari SearchProviderIdentifier "com.duckduckgo"
function defaults_set_str() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	
	local domain="$1"
	local key="$2"
	local value="$3"
	
	# Note: We do not handle the case where the key does not have the correct type
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error.
	current_value="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null)" || true
	test "$current_value" != "$value" || { echo "ok"; return }
	
	defaults $defaults_options write "$domain" "$key" -string "$value" >/dev/null 2>&1 || { log_task_failure "cannot set string value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}

## Set an integer value for the given key using macOS defaults CLT.
## Usage: defaults_set_int [-currentHost] domain key value
## Example: defaults_set_int NSGlobalDomain KeyRepeat 2
function defaults_set_int() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	
	local domain="$1"
	local key="$2"
	local value="$3"
	
	# Note: We do not handle the case where the key does not have the correct type
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error.
	current_value="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null)" || true
	test "$current_value" != "$value" || { echo "ok"; return }
	
	defaults $defaults_options write "$domain" "$key" -int "$value" >/dev/null 2>&1 || { log_task_failure "cannot set integer value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}

## Set a bool value for the given key using macOS defaults CLT.
## For the value, anything other than 0 will be considered to be true.
## Usage: defaults_set_bool [-currentHost] domain key value
## Example: defaults_set_bool NSGlobalDomain NSQuitAlwaysKeepsWindows 1
function defaults_set_bool() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	
	local domain="$1"
	local key="$2"
	local value="$3"
	
	if test "$value" = "0"; then expected_value="0"; value_to_set="no";
	else                         expected_value="1"; value_to_set="yes"; fi
	
	# Note: We do not handle the case where the key does not have the correct type
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error.
	current_value="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null)" || true
	test "$current_value" != "$expected_value" || { echo "ok"; return }
	
	defaults $defaults_options write "$domain" "$key" -bool "$value_to_set" >/dev/null 2>&1 || { log_task_failure "cannot set bool value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}
