#!/bin/bash
set -euo pipefail


# For now we use a fixed Swift toolchain, SDK name and co.
# We’ll have to change those when our local machine configuration changes.
readonly SWIFT_SDK_NAME="aarch64-unknown-linux-android24"
readonly SWIFT_TOOLCHAIN="$HOME/Library/Developer/Toolchains/swift-6.0.3-RELEASE.xctoolchain"
readonly PATH_TO_SWIFT_LIBS="$HOME/Library/org.swift.swiftpm/swift-sdks/swift-6.0.3-RELEASE-android-24-0.1.artifactbundle/swift-6.0.3-release-android-24-sdk/android-27c-sysroot/usr/lib/aarch64-linux-android"

# Verify adb exists where we think it does.
# This is very ad-hoc and oh so specific to my machine and configuration!
readonly adb_path="$HOME/.local/share/android/sdk/platform-tools/adb"
test -x "$adb_path" || {
	echo "adb is not at the expected location." >&2
	exit 1
}

# Let’s see if we can run a shell command on any device.
# To run a device manually, one can run `emulator -avd $AVD_ID -no-boot-anim -no-window` for instance.
# We do not check on which device the command run and assume any device is fine.
"$adb_path" shell true || {
	echo "Cannot start a shell on an avd device." >&2
	echo "Please make sure you have at least one device up and running." >&2
	"$adb_path" kill-server
	exit 1
}

# Retrieve the name of the package; we’ll need it later to launch the tests.
package_name="$(swift package dump-package | jq -r .name)" || { echo "Failed retrieving the name of the package." >&2; exit 1; }
readonly package_name

# Build the project.
swift build --build-tests --toolchain "$SWIFT_TOOLCHAIN" --swift-sdk "$SWIFT_SDK_NAME"

# Create a pack with the required contents for testing on an android device.
readonly pack_destination="${TMPDIR:-/tmp}/testing-pack-for-android--$package_name"
! test -e "$pack_destination/.lock" || {
	# The destination pack is locked.
	# We ask the user if he wants to continue anyway or abort.
	read -p "The destination pack is locked. Do you want to continue anyway? " -n 2 r
	while [ "$r" != "" -a $(echo "$r" | wc -c) -gt 2 ]; do read -n 2 f; done
	if [ "$r" != "y" ]; then exit 1; fi
	rm -fr "$pack_destination"
}
mkdir -p "$pack_destination" || { echo "Failed creating pack folder." >&2; exit 1; }
touch "$pack_destination/.lock"
trap 'rm -f "$pack_destination/.lock"' EXIT

rsync -avHXA --include "/.build/$SWIFT_SDK_NAME/***" --exclude '/.build/*' --exclude '/.git' --exclude '/.swiftpm' ./ "$pack_destination/" || { echo "Failed copying artifacts in the pack folder." >&2; exit 1; }
cp "$PATH_TO_SWIFT_LIBS"/*.so "$pack_destination/.build/$SWIFT_SDK_NAME/debug/" || { echo "Failed copying shared objects to the pack folder." >&2; exit 1; }

# Sync the pack to the device and run the test suite.
# Note push --sync does NOT delete absent files from the device.
readonly remote_pack_path="/data/local/tmp/$package_name-testing"
# We assume no quotes in the remote pack path…
"$adb_path" shell "rm -fr \"$remote_pack_path\""
"$adb_path" push "$pack_destination" "$remote_pack_path" || { echo "Failed syncing pack to device." >&2; exit 1; }
"$adb_path" shell "cd \"$remote_pack_path\"; \"./.build/$SWIFT_SDK_NAME/debug/${package_name}PackageTests.xctest\""
