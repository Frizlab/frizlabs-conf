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
env=home
base_image_name=debian
base_image_tag=stretch-slim
final_image_name="frizlab-$env-$base_image_name:$base_image_tag"
builder_image_name="frizlab-conf-builder-$base_image_name:$base_image_tag"
echo "$env" >"$ASSETS_INPUTS_FOLDER/ansible_group"
docker build . -f "debian-stretch/Dockerfile.base" --build-arg BASE_IMAGE_NAME="$base_image_name" --build-arg BASE_IMAGE_TAG="$base_image_tag" -t "$builder_image_name"
docker build . -f "debian-stretch/Dockerfile.user" --build-arg BASE_IMAGE="$builder_image_name" -t "$final_image_name"
docker run --rm "$final_image_name" "test-frizlabs-conf.sh"
