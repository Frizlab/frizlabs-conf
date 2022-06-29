#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob

cd "$(dirname "$0")/.."

printf "./runs/"
ls -1 "./runs" | tail -n 1
