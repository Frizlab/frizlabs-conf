#!/bin/bash
set -euo pipefail


command -v "realpath" >/dev/null || { echo "realpath is required for this script." >&2; exit 1; }


# For now we use a fixed Swift toolchain, SDK name and co.
# We’ll have to change those when our local machine configuration changes.
readonly SWIFT_SDK_NAME="swift-6.2-RELEASE_wasm"
readonly SWIFT_TOOLCHAIN="$HOME/Library/Developer/Toolchains/swift-6.2-RELEASE.xctoolchain"

# Retrieve the name of the package; we’ll need it later to launch the tests.
package_name="$(swift package dump-package | jq -r .name)" || { echo "Failed retrieving the name of the package." >&2; exit 1; }
readonly package_name

swift build --build-tests --toolchain "$SWIFT_TOOLCHAIN" --swift-sdk "$SWIFT_SDK_NAME"
wasmtime --dir "." --dir "$(realpath .)" --dir "/tmp" ".build/debug/${package_name}PackageTests.xctest"
