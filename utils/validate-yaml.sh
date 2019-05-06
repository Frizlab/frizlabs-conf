#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob

file="$1"

ruby -ryaml -e "p YAML.load(STDIN.read)" <"$file"
