#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/assets"


readonly LINUX_BASE_IMAGES=("debian:stretch-slim" "debian:buster-slim")

readonly ASSETS_INPUTS_FOLDER="inputs"
readonly VAULT_ID_PATH="../../.cache/.vault-id"


mkdir -p "$ASSETS_INPUTS_FOLDER"

# Setting up the vault id
test -f "$VAULT_ID_PATH" || { echo "vault-id is not setup; aborting" >/dev/stderr; exit 1; }
cp -f "$VAULT_ID_PATH" "$ASSETS_INPUTS_FOLDER/.vault-id"


#set -vx
for linux_base_image in "${LINUX_BASE_IMAGES[@]}"; do
	linux_base_image_os="${linux_base_image%:*}"
	linux_base_image_no_colon="${linux_base_image//:/_}"
	
	for user in root normaluser; do
		for env in home work; do
			# Setting up the ansible group
			echo "$env" >"$ASSETS_INPUTS_FOLDER/ansible_group"
			
			# Creating the Dockerfile for our configuration
			dockerfilepath="$(mktemp)"
			m4 -DM4_USER="$user" -DM4_BASE_IMAGE="$linux_base_image" "linux/Dockerfile.m4" >"$dockerfilepath"
			
			# Building the image
			image_name="frizlab-conf-test-$env-$user:$linux_base_image_no_colon"
			docker rmi "$image_name" 2>/dev/null || true; # First remove the previous test image if present
			docker build . -f "$dockerfilepath" -t "$image_name"
			rm -f "$dockerfilepath"
			
			# Running the test script inside the image
			docker run --rm "$image_name" "/usr/local/bin/test-frizlabs-conf.sh"
		done
	done
done
