#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob

cd "$(dirname "$0")/.."

p="$(ls -1 "./runs" 2>/dev/null || true | tail -n 1)"
test -n "$p" && printf "./runs/%s" "$p" || { printf "No runs; returning /dev/null.\n" >&2; printf "/dev/null"; }
