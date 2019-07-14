#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/assets"


readonly LINUX_BASE_IMAGES=("debian:stretch-slim")

readonly ASSETS_INPUTS_FOLDER="inputs"
readonly VAULT_ID_PATH="../../.cache/.vault-id"


mkdir -p "$ASSETS_INPUTS_FOLDER"

# Setting up the vault id
test -f "$VAULT_ID_PATH" || { echo "vault-id is not setup; aborting" >/dev/stderr; exit 1; }
cp -f "$VAULT_ID_PATH" "$ASSETS_INPUTS_FOLDER/.vault-id"


#set -vx
for LINUX_BASE_IMAGE in "${LINUX_BASE_IMAGES[@]}"; do

	LINUX_BASE_IMAGE_OS="${LINUX_BASE_IMAGE%:*}"
	LINUX_BASE_IMAGE_NO_COLON="${LINUX_BASE_IMAGE//:/_}"

	# Getting base Dockerfile name
	BASE_DOCKERFILE_EXTENSION=
	case "$LINUX_BASE_IMAGE_OS" in
		debian) BASE_DOCKERFILE_EXTENSION="debian";;
		ubuntu) BASE_DOCKERFILE_EXTENSION="debian";;
		*) echo "Unknown Linux distribution; aborting test for base docker image “${LINUX_BASE_IMAGE}”" >/dev/stderr; continue;;
	esac

	# Building the base image
	image_builder_step1_name="frizlab-conf-builder-step1:$LINUX_BASE_IMAGE_NO_COLON"
	docker build . -f "linux/Dockerfile.base.$BASE_DOCKERFILE_EXTENSION" --build-arg BASE_IMAGE="$LINUX_BASE_IMAGE" -t "$image_builder_step1_name"

	for user_mode in root user; do
		# Building the step2 base image
		image_builder_step2_name="frizlab-conf-builder-$user_mode-step2:$LINUX_BASE_IMAGE_NO_COLON"
		docker build . -f "linux/Dockerfile.$user_mode" --build-arg BASE_IMAGE="$image_builder_step1_name" -t "$image_builder_step2_name"

		for env in home work; do
			# Setting up the ansible group
			echo "$env" >"$ASSETS_INPUTS_FOLDER/ansible_group"

			# Building the final image
			final_image_name="frizlab-conf-test-$env-$user_mode:$LINUX_BASE_IMAGE_NO_COLON"
			docker build . -f "linux/Dockerfile.install" --build-arg BASE_IMAGE="$image_builder_step2_name" -t "$final_image_name"

			# Running the test script inside the image
			docker run --rm "$final_image_name" "/usr/local/bin/test-frizlabs-conf.sh"

			# This image must be removed if the test succeed, so that the next test
			# will rebuild the image.
			# Note however that we could keep the image. I tested it, it works.
			docker rmi "$final_image_name"
		done

		docker rmi "$image_builder_step2_name"
	done

	# We can keep this intermediary to avoid re-building it later…
#	docker rmi "$image_builder_step1_name"
done
