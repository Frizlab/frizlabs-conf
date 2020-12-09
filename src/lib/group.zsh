# Get computer group (home, work, etc.)
readonly COMPUTER_GROUP_PATH="$CACHE_FOLDER/computer_group"
declare -rA COMPUTER_GROUPS=(
	1 home
	2 work
)

test -f "$COMPUTER_GROUP_PATH" || {
	message=
	message+=$'What group is your computer in?\n\n'
	message+=$'Choose a number (group will be "unknown" if any other value is given):\n'
	for k v in ${(kv)COMPUTER_GROUPS}; do
		message+="   $k) $v"$'\n'
	done
	message+='Your choice: '
	read -r "group?$message"
	echo -n "${COMPUTER_GROUPS[$group]}" >"$COMPUTER_GROUP_PATH"
}
# Note: We use tmpvar to actually fail on cat error
tmpvar="$(cat "$COMPUTER_GROUP_PATH")"
readonly COMPUTER_GROUP="$tmpvar"
