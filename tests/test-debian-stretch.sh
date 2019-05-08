#!/bin/bash
# vim: ts=3 sw=3 noet

set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/assets"

readonly LINUX_DISTRIBUTION=debian
readonly LINUX_DISTRIBUTION_RELEASE=stretch-slim

readonly ASSETS_INPUTS_FOLDER="inputs"
readonly VAULT_ID_PATH="../../.cache/.vault-id"

mkdir -p "$ASSETS_INPUTS_FOLDER"

# Setting up the vault id
test -f "$VAULT_ID_PATH" || ( echo "vault-id is not setup; aborting" && exit 1 )
cp -f "$VAULT_ID_PATH" "$ASSETS_INPUTS_FOLDER/.vault-id"

# Building the base image
image_builder_step1_name="frizlab-conf-builder-step1-$LINUX_DISTRIBUTION:$LINUX_DISTRIBUTION_RELEASE"
docker build . -f "debian-stretch/Dockerfile.base" --build-arg BASE_IMAGE_NAME="$LINUX_DISTRIBUTION" --build-arg BASE_IMAGE_TAG="$LINUX_DISTRIBUTION_RELEASE" -t "$image_builder_step1_name"

for env in home work; do
	# Setting up the ansible group
	echo "$env" >"$ASSETS_INPUTS_FOLDER/ansible_group"

	for user_mode in root user; do
		# Building the step2 base image
		image_builder_step2_name="frizlab-conf-builder-$env-$user_mode-step2-$LINUX_DISTRIBUTION:$LINUX_DISTRIBUTION_RELEASE"
		docker build . -f "debian-stretch/Dockerfile.$user_mode" --build-arg BASE_IMAGE="$image_builder_step1_name" -t "$image_builder_step2_name"

		# Building the final image
		final_image_name="frizlab-$env-$user_mode-$LINUX_DISTRIBUTION:$LINUX_DISTRIBUTION_RELEASE"
		docker build . -f "debian-stretch/Dockerfile.install" --build-arg BASE_IMAGE="$image_builder_step2_name" -t "$final_image_name"

		# Running the test script inside the image
		docker run --rm "$final_image_name" "/usr/local/bin/test-frizlabs-conf.sh"
	done
done
