# Get computer group (home, work, etc.)
readonly COMPUTER_GROUP_PATH="$CACHE_FOLDER/computer_group"
declare -rA COMPUTER_GROUPS=(
	1 home
	2 work
	3 vm
)

test -f "$COMPUTER_GROUP_PATH" || {
	message=
	message+=$'What group is your computer in?\n\n'
	message+=$'Choose a number (group will be "unknown" if any other value is given):\n'
	for k in ${(kon)COMPUTER_GROUPS}; do
		message+="   $k) $COMPUTER_GROUPS[$k]"$'\n'
	done
	message+='Your choice: '
	read -r "group?$message"
	if [ "$group" -gt 0 -a "$group" -le "${#COMPUTER_GROUPS[@]}" ] 2>/dev/null; then
		echo -n "${COMPUTER_GROUPS[$group]}" >"$COMPUTER_GROUP_PATH"
	else
		echo -n "unknown" >"$COMPUTER_GROUP_PATH"
	fi
}
COMPUTER_GROUP="$(cat "$COMPUTER_GROUP_PATH")"; readonly COMPUTER_GROUP
