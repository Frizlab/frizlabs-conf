#!/bin/bash
set -euo pipefail



action=
if   test $# -eq 0; then action="push"
elif test $# -eq 1; then action="$1"
fi


cd "$(git rev-parse --show-toplevel)"
case "$action" in
	push)
		git add .
		git commit -am"WIP"
		git push;# --force-with-lease
		git reset --hard HEAD~
		;;
	pull)
		dirty_witness="$(git status --porcelain --untracked-files=no 2>/dev/null | head -n 1)"
		test -z "$dirty_witness" || { echo "Refusing to pull WIP from dirty repo." >&2; exit 2; }
		
		git fetch -f
		git rebase
		last_commit_msg="$(git log -1 --pretty=format:%B)"
		test "$last_commit_msg" = "WIP" || { echo "Last commit message is not WIP; aborting." >&2; exit 3; }
		
		git reset HEAD~
		git add .
		git push --force-with-lease
		;;
	*)
		echo "Usage: $0 [push|pull]" >&2
		exit 1
		;;
esac
