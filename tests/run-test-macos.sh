#!/bin/bash
set -euo pipefail

MACHINE_NAME=conf-test-catalina

prlctl snapshot-switch "$MACHINE_NAME" -i "{694a7bc7-fe9d-4ffa-a4e5-46a597028433}"
# The status of the snapshot is poweron, so no need to start the VM (we could use jq to check the status; no need here).
#prlctl start "$MACHINE_NAME"

echo "Waiting for machine to be up"
while ! ping -c 1 "$MACHINE_NAME" >/dev/null 2>&1; do sleep 0; done
# Waiting 1 second more, to be safe.
sleep 1

echo "TODO: Run the install and the tests"
