#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob

ag --ignore "./.cache" --ignore "./scripts/todos.sh" TODO
