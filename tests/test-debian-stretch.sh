#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/assets"

readonly ASSETS_INPUTS_FOLDER="inputs"
readonly VAULT_ID_PATH="../../.cache/.vault-id"

mkdir -p "$ASSETS_INPUTS_FOLDER"

# Setting up the vault id
test -f "$VAULT_ID_PATH" || ( echo "vault-id is not setup; aborting" && exit 1 )
cp -f "$VAULT_ID_PATH" "$ASSETS_INPUTS_FOLDER/.vault-id"

# Setting up the ansible group
echo "home" >"$ASSETS_INPUTS_FOLDER/ansible_group"
docker build . -f "debian-stretch/Dockerfile.root" -t frizlab-home-debian:stretch
docker run --rm frizlab-home-debian:stretch "test-frizlabs-conf.sh"
