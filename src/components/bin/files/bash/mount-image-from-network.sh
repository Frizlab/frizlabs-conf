#!/bin/bash
set -euo pipefail


# ##### ARGS ##### #

test $# -eq 8 || {
	echo "Usage: $0 keychain_file nas_scheme nas_scheme_mounter nas_server nas_username nas_relative_path nas_mount_path image_relative_path" >&2
	echo >&2
	echo "Example: $0 script-passwords.keychain smb smbfs my-server.local bob.kelso Homes/BobKelso /tmp/mount-folder Private/Backups.sparsebundle" >&2
	exit 1
}

readonly KEYCHAIN_PATH="$1"; shift

readonly NAS_SCHEME="$1";         shift
readonly NAS_SCHEME_MOUNTER="$1"; shift
readonly NAS_SERVER="$1";         shift
readonly NAS_USERNAME="$1";       shift
readonly NAS_RELATIVE_PATH="$1";  shift
readonly NAS_MOUNT_PATH="$1";     shift

readonly IMAGE_RELATIVE_PATH="$1"; shift
readonly IMAGE_NAME="${IMAGE_RELATIVE_PATH##*/}"


# ##### PREREQUISITES ##### #

# Let’s check jq and get-mount-points are installed.
command -v "jq"               >/dev/null || { echo "jq is required for this script."               >&2; exit 1; }
command -v "get-mount-points" >/dev/null || { echo "get-mount-points is required for this script." >&2; exit 1; }


# ##### PASSWORDS RETRIEVAL ##### #

NAS_SCHEME_FOUR_CHAR="$(printf "%-4s" "$NAS_SCHEME")"; readonly NAS_SCHEME_FOUR_CHAR

# Because of the tr, the password cannot contain a newline (no big deal…).
# We need the tr (at least for the first pass) because otherwise jq converts the trailing newline (from security tool) to its urlencoded value.
  NAS_PASS="$(security find-internet-password -a "$NAS_USERNAME" -s "$NAS_SERVER" -D "network password"    -r "$NAS_SCHEME_FOUR_CHAR" -w "$KEYCHAIN_PATH" | tr -d '\n' | jq -sRr "@uri")"; readonly NAS_PASS
IMAGE_PASS="$(security find-generic-password  -a "dummy"         -s "$IMAGE_NAME" -D "disk image password"                            -w "$KEYCHAIN_PATH" | tr -d '\n')";                  readonly IMAGE_PASS


# ##### MOUNT NAS ##### #

#echo "Mounting NAS..." >&2

readonly NAS_URL="$NAS_SCHEME://$NAS_USERNAME:$NAS_PASS@$NAS_SERVER/$NAS_RELATIVE_PATH"
"mount_$NAS_SCHEME_MOUNTER" "$NAS_URL" "$NAS_MOUNT_PATH"


# ##### MOUNT IMAGE ##### #

#echo "Mounting Image..." >&2

readonly IMAGE_PATH="$NAS_MOUNT_PATH/$IMAGE_RELATIVE_PATH"
echo -n "$IMAGE_PASS" | hdiutil mount -stdinpass "$IMAGE_PATH" >/dev/null


# ##### OUTPUT MOUNT POINT ##### #

IMAGE_MOUNT_PATH="$(get-mount-points "$IMAGE_PATH")"
# get-mount-points returns a path without trailing slash, but we want to be sure.
#IMAGE_MOUNT_PATH="${IMAGE_MOUNT_PATH%/}"
readonly IMAGE_MOUNT_PATH
echo "$IMAGE_MOUNT_PATH"


## ##### CLEANUP ##### #

#echo "Ejecting Image..." >&2
#hdiutil eject "$IMAGE_MOUNT_PATH"
#echo "Unmounting NAS..." >&2
#umount "$NAS_MOUNT_PATH"
#rmdir "$NAS_MOUNT_PATH"
