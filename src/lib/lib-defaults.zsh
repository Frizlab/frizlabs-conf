# Deal with macOS defaults.


## Set a bool value for the given key using macOS defaults CLT.
## For the value, anything other than 0 will be considered to be true.
## Usage: libdefaults__set_bool [-currentHost] domain key value
## Example: libdefaults__set_bool NSGlobalDomain NSQuitAlwaysKeepsWindows 1
function libdefaults__set_bool() {
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
	
	# We fully ignore if defaults cannot read the default at all, because it will probably be because the key does not exist and it is a normal error.
	# We also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var declaration, so there is no need to “|| true” the call.
	local -r current_value="$(run_and_log_keep_stdout defaults $defaults_options read "$domain" "$key")"
	run_and_log test "$current_value" != "$expected_value" || { echo "ok"; return }
	
	run_and_log defaults $defaults_options write "$domain" "$key" -bool "$value_to_set" || { log_task_failure "cannot set bool value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}


## Set an integer value for the given key using macOS defaults CLT.
## Usage: libdefaults__set_int [-currentHost] domain key value
## Example: libdefaults__set_int NSGlobalDomain KeyRepeat 2
function libdefaults__set_int() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	# We fully ignore if defaults cannot read the default at all, because it will probably be because the key does not exist and it is a normal error.
	# We also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var declaration, so there is no need to “|| true” the call.
	local -r current_value="$(run_and_log_keep_stdout defaults $defaults_options read "$domain" "$key")"
	run_and_log test "$current_value" != "$value" || { echo "ok"; return }
	
	run_and_log defaults $defaults_options write "$domain" "$key" -int "$value" || { log_task_failure "cannot set integer value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}


## Set a string value for the given key using macOS defaults CLT.
## Usage: libdefaults__set_str [-currentHost] domain key value
## Example: libdefaults__set_str com.apple.Safari SearchProviderIdentifier "com.duckduckgo"
function libdefaults__set_str() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	# We fully ignore if defaults cannot read the default at all, because it will probably be because the key does not exist and it is a normal error.
	# We also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var declaration, so there is no need to “|| true” the call.
	local -r current_value="$(run_and_log_keep_stdout defaults $defaults_options read "$domain" "$key")"
	run_and_log test "$current_value" != "$value" || { echo "ok"; return }
	
	run_and_log defaults $defaults_options write "$domain" "$key" -string "$value" || { log_task_failure "cannot set string value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}


## Set a plist value for the given key using macOS defaults CLT.
## Usage: libdefaults__set_plist [-currentHost] domain key value
## Example: libdefaults__set_plist NSGlobalDomain NSPreferredWebServices '{NSWebServicesProviderWebSearch = { NSDefaultDisplayName = DuckDuckGo; NSProviderIdentifier = "com.duckduckgo"; }; }'
function libdefaults__set_plist() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	local -r value="$3"
	
	# We fully ignore if defaults cannot read the default at all, because it will probably be because the key does not exist and it is a normal error.
	# We also don’t care about any type mismatch.
	# Important: The error defaults could return is “hidden” by the “local” var declaration, so there is no need to “|| true” the call.
	local -r current_value_xml="$(run_and_log_keep_stdout defaults $defaults_options read "$domain" "$key" | run_and_log_keep_stdout plutil -convert xml1 -o - -)"
	local value_xml; value_xml="$(run_and_log_keep_stdout echo "$value" | run_and_log_keep_stdout plutil -convert xml1 -o - -)"; readonly value_xml
	run_and_log test "$current_value_xml" != "$value_xml" || { echo "ok"; return }
	
	run_and_log defaults $defaults_options write "$domain" "$key" "$value" || { log_task_failure "cannot set plist value for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}


## Add some dictionary values in a given key using macOS defaults CLT. The key’s
## value must either not already exist or be a dictionary.
## Usage: libdefaults__add_dict [-currentHost] domain key dict_key1 dict_value1 dict_key2 dict_value2 ...
## Example: libdefaults__add_dict com.apple.Safari "NSToolbar Configuration BrowserToolbarIdentifier-v4.6" "TB Default Item Identifiers" '(CombinedSidebarTabGroupToolbarIdentifier, SidebarSeparatorToolbarItemIdentifier, UnifiedTabBarToolbarIdentifier, ShareToolbarIdentifier, NewTabToolbarIdentifier)'
function libdefaults__add_dict() {
	local defaults_options=
	if [ "$1" = "-currentHost" ]; then
		defaults_options="-currentHost"
		shift
	fi
	readonly defaults_options
	
	local -r domain="$1"
	local -r key="$2"
	shift; shift
	
	local witness=
	for k v in "$@"; do
		# We fully ignore if defaults cannot read the default at all, because it will probably be because the key does not exist and it is a normal error.
		# We also don’t care about any type mismatch.
		# Important: The error defaults could return is “hidden” by the “local” var declaration, so there is no need to “|| true” the call.
		local current_value_xml="$(run_and_log_keep_stdout defaults $defaults_options read "$domain" "$key" | run_and_log_keep_stdout plutil -extract "$k" xml1 -o - -)"
		local value_xml; value_xml="$(run_and_log_keep_stdout echo "$v" | run_and_log_keep_stdout plutil -convert xml1 -o - -)"
		run_and_log test "$current_value_xml" = "$value_xml" || { witness=diff; break }
	done
	run_and_log test -n "$witness" || { echo "ok"; return }
	
	run_and_log defaults $defaults_options write "$domain" "$key" -dict-add "$@" || { log_task_failure "cannot add dict for defaults domain $domain key $key"; echo "failed"; return }
	echo "changed"
}