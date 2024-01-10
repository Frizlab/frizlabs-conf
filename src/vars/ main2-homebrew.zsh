# Main system Homebrew instance directories (official installation paths)
case "$HOST_OS" in
	Darwin)
		readonly HOMEBREW_ARM64_SYSTEM_DIR="/opt/homebrew"
		readonly HOMEBREW_X86_SYSTEM_DIR="/usr/local"
	;;
	Linux)
		# AFAIK there there is no official path for Linuxbrew on arm64 (because there are no bottles for this arch for Linux).
		# So we use a custom path for the arm64 Linux brew install.
		# See <https://docs.brew.sh/Homebrew-on-Linux#arm>.
		readonly HOMEBREW_ARM64_SYSTEM_DIR="/home/linuxbrew/.linuxbrew-arm64"
		readonly HOMEBREW_X86_SYSTEM_DIR="/home/linuxbrew/.linuxbrew"
	;;
	*) fatal "Unknown host $HOST_OS; cannot set homebrew paths.";;
esac

case "$HOST_ARCH" in
	# On Linux it’s aarch64 apparently.
	arm64|aarch64)
		readonly HOMEBREW_USER_DIR="$HOMEBREW_ARM64_USER_DIR"
		readonly HOMEBREW_SYSTEM_DIR="$HOMEBREW_ARM64_SYSTEM_DIR"
	;;
	x86_64)
		readonly HOMEBREW_USER_DIR="$HOMEBREW_X86_USER_DIR"
		readonly HOMEBREW_SYSTEM_DIR="$HOMEBREW_X86_SYSTEM_DIR"
	;;
	*) fatal "Unknown arch $HOST_ARCH; cannot set homebrew paths.";;
esac
