#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/assets"


# Too old: "debian:jessie-slim"
readonly LINUX_BASE_IMAGES=(
	"debian:stable-slim" "debian:10-slim" "debian:9-slim"
	"ubuntu:latest" "ubuntu:20.04" "ubuntu:18.04" "ubuntu:16.04"
)

readonly ASSETS_INPUTS_FOLDER="inputs"
readonly PASS1_PATH="../../.cache/.pass1"
readonly PASS2_PATH="../../.cache/.pass2"
readonly PASS3_PATH="../../.cache/.pass3"


mkdir -p "$ASSETS_INPUTS_FOLDER"

# Setting up the passwords
{ test -f "$PASS1_PATH" && test -f "$PASS2_PATH" && test -f "$PASS3_PATH"; } || { echo "One of the pass is not setup; aborting" >/dev/stderr; exit 1; }
cp -f "$PASS1_PATH" "$PASS2_PATH" "$PASS3_PATH" "$ASSETS_INPUTS_FOLDER"


#set -vx
for linux_base_image in "${LINUX_BASE_IMAGES[@]}"; do
	docker pull "$linux_base_image"
	
	linux_base_image_os="${linux_base_image%:*}"
	linux_base_image_no_colon="${linux_base_image//:/_}"
	
	for user in root normaluser; do
		for env in home work; do
			# Setting up the ansible group
			echo "$env" >"$ASSETS_INPUTS_FOLDER/computer_group"
			
			# Creating the Dockerfile for our configuration
			dockerfilepath="$(mktemp)"
			m4 -DM4_USER="$user" -DM4_BASE_IMAGE="$linux_base_image" "linux/Dockerfile.m4" >"$dockerfilepath"
			
			# Building the image
			image_name="frizlab-conf-test-$env-$user:$linux_base_image_no_colon"
			docker rmi "$image_name" 2>/dev/null || true; # First remove the previous test image if present
			docker build --build-arg CACHEBUST="$(date +%s)" . -f "$dockerfilepath" -t "$image_name"
			rm -f "$dockerfilepath"
			
			# Running the test script inside the image
			docker run --rm "$image_name" "/usr/local/bin/test-frizlabs-conf.sh"
		done
	done
done
