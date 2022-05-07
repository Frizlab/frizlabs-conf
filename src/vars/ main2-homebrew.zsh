# Main system Homebrew instance directories (official installation paths)
if test "$HOST_OS" = "Darwin"; then
	readonly HOMEBREW_X86_SYSTEM_DIR="/usr/local"
	readonly HOMEBREW_ARM64_SYSTEM_DIR="/opt/homebrew"
else
	readonly HOMEBREW_X86_SYSTEM_DIR="/home/linuxbrew/.linuxbrew"
	# Official installation path does not exist (yet?)
	readonly HOMEBREW_ARM64_SYSTEM_DIR="/home/linuxbrew/.linuxbrew-arm64"
fi

if test "$HOST_OS:$HOST_ARCH" != "Darwin:arm64"; then
	readonly HOMEBREW_USER_DIR="$HOMEBREW_X86_USER_DIR"
	readonly HOMEBREW_SYSTEM_DIR="$HOMEBREW_X86_SYSTEM_DIR"
else
	readonly HOMEBREW_USER_DIR="$HOMEBREW_ARM64_USER_DIR"
	readonly HOMEBREW_SYSTEM_DIR="$HOMEBREW_ARM64_SYSTEM_DIR"
fi
