# The CLT (Command-Line Tools) directory.
readonly CLT_DIR="$HOME/clt"

# Envs (Python envs, Ruby gems, etc.).
readonly CLT_ENVS_DIR="$CLT_DIR/envs"
# Logs from some CLT tools (e.g. launchd output).
readonly CLT_LOGS_DIR="$CLT_DIR/logs"

# The user’s CLT directory.
# All binaries/scripts whose author is the same as the current user will go there.
readonly FIRST_PARTY_CLT_DIR="$CLT_DIR/1st-party-ad-hoc"
readonly FIRST_PARTY_BIN_DIR="$FIRST_PARTY_CLT_DIR/bin"
readonly FIRST_PARTY_SBIN_DIR="$FIRST_PARTY_CLT_DIR/sbin"
readonly FIRST_PARTY_SHARE_DIR="$FIRST_PARTY_CLT_DIR/share"
readonly FIRST_PARTY_BASH_COMPLETIONS="$FIRST_PARTY_SHARE_DIR/bash/completions"
readonly FIRST_PARTY_ZSH_SITE_FUNCTIONS="$FIRST_PARTY_SHARE_DIR/zsh/site-functions"

# Other binaries and scripts.
readonly THIRD_PARTY_CLT_DIR="$CLT_DIR/3rd-party-ad-hoc"
readonly THIRD_PARTY_BIN_DIR="$THIRD_PARTY_CLT_DIR/bin"
readonly THIRD_PARTY_SBIN_DIR="$THIRD_PARTY_CLT_DIR/sbin"
readonly THIRD_PARTY_SHARE_DIR="$THIRD_PARTY_CLT_DIR/share"
readonly THIRD_PARTY_BASH_COMPLETIONS="$THIRD_PARTY_SHARE_DIR/bash/completions"
readonly THIRD_PARTY_ZSH_SITE_FUNCTIONS="$THIRD_PARTY_SHARE_DIR/zsh/site-functions"

# The arm64 user Homebrew instance directory
readonly HOMEBREW_ARM64_USER_DIR="$CLT_DIR/homebrew-arm64"
# The x86 user Homebrew instance directory
readonly HOMEBREW_X86_USER_DIR="$CLT_DIR/homebrew-x86"
