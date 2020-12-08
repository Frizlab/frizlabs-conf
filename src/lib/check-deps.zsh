# Check the required dependencies are installed
case "$HOST_OS" in
	"Darwin")
		xcode-select -p >/dev/null 2>&1 || {
			echo "The Xcode Command Line Tools (or Xcode) is required for this script to work. Run 'xcode-select --install' to get the CLT." >&2
			exit 1
		}
	;;
	"Linux")
		# ccdecrypt is the only truly required dependency. Other binaries are
		# needed _after_ the configuration is installed.
		readonly DEPS=("ccdecrypt" "git" "locale-gen")
		for dep in $DEPS; do
			command -v "$dep" >/dev/null 2>&1 || {
				echo "The following dependencies are required (at least one of them is missing): $DEPS" >&2
				exit 1
			}
		done
	;;
	*)
		echo "Unknown host OS: $HOST_OS" >&2
		exit 1
	;;
esac
