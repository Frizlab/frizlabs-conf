#!/bin/bash
set -euo pipefail

test $# -eq 3 || { echo "Usage: $0 folder orgname username:PAT" >&2; exit 1; }

folder="$1"
orgname="$2"
auth="$3"

cd "$folder"
n=0; while true; do
	n=$((n+1))
	urls="$(curl -su "$auth" "https://api.github.com/orgs/$orgname/repos?type=all&page=$n" | jq -r '.[] | .ssh_url')"
	[ -z "$urls" ] && break
	for url in $urls; do
		basename="$(basename "$url")"
		if [ -d "$basename" ]; then git -C "$basename" remote update --prune
		else                        git clone --mirror "$url"
		fi
	done
done
