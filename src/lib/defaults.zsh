# Deal with macOS defaults

## Set a plist value for the given key using macOS defaults CLT.
## Usage: defaults_set_plist [-currentHost] domain key value
## Example: defaults_set_plist NSGlobalDomain NSPreferredWebServices '{NSWebServicesProviderWebSearch = { NSDefaultDisplayName = DuckDuckGo; NSProviderIdentifier = "com.duckduckgo"; }; }'
function defaults_set_plist() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error. We
	# also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var
	#            declaration, so there is no need to “|| true” the call.
	local -r current_value_xml="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null | plutil -convert xml1 -o - -)"
	local value_xml; value_xml="$(echo "$value" | plutil -convert xml1 -o - -)"; readonly value_xml
	test "$current_value_xml" != "$value_xml" || { echo "ok"; return }
	
	defaults $defaults_options write "$domain" "$key" "$value" >/dev/null 2>&1 || { log_task_failure "cannot set plist value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}

## Set a string value for the given key using macOS defaults CLT.
## Usage: defaults_set_str [-currentHost] domain key value
## Example: defaults_set_str com.apple.Safari SearchProviderIdentifier "com.duckduckgo"
function defaults_set_str() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error. We
	# also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var
	#            declaration, so there is no need to “|| true” the call.
	local -r current_value="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null)"
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
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error. We
	# also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var
	#            declaration, so there is no need to “|| true” the call.
	local -r current_value="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null)"
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
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	local value_to_set expected_value
	if test "$value" = "0"; then expected_value="0"; value_to_set="no";
	else                         expected_value="1"; value_to_set="yes"; fi
	readonly value_to_set expected_value
	
	# We fully ignore if defaults cannot read the default at all, because it will
	# probably be because the key does not exist and it is a normal error. We
	# also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var
	#            declaration, so there is no need to “|| true” the call.
	local -r current_value="$(defaults $defaults_options read "$domain" "$key" 2>/dev/null)"
	test "$current_value" != "$expected_value" || { echo "ok"; return }
	
	defaults $defaults_options write "$domain" "$key" -bool "$value_to_set" >/dev/null 2>&1 || { log_task_failure "cannot set bool value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}
