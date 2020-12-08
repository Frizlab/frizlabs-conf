#!/bin/bash

check_connection() {
	curl --max-time 7 www.apple.com >/dev/null 2>&1
}

kill_subprocesses() {
	pid=$1
	for child in $(ps -o pid,ppid | awk "{if (\$2 == $pid) {print \$1}}"); do
		#echo kill $child
		kill $child
	done
	#echo kill $pid
	kill $pid
}

connect_netsoul="$(which "connect-netsoul")"
if [ ! -x "$connect_netsoul" ]; then
	echo "could not find the connect-netsoul script" >&2
	exit 2
fi

cur_pid=
while true; do
	if check_connection; then
		sleep 5
	else
		echo "Server does not have an Internet connection. Trying to re-connect NetSoul." >&2
		if [ -n "$cur_pid" ]; then kill_subprocesses "$cur_pid"; fi
		"$connect_netsoul" &
		cur_pid="$!"
		echo "Child's PID: $cur_pid"
	fi
	sleep 1
done
