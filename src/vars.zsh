# The Applications directory.
readonly APP_DIR="$HOME/Applications"

# The CLT (Command-Line Tools) directory.
readonly CLT_DIR="$HOME/clt"

# The user’s CLT directory. All binaries/scripts whose author is the same as the
# current user will go there.
readonly FIRST_PARTY_CLT_DIR="$CLT_DIR/1st-party-ad-hoc"
readonly FIRST_PARTY_BIN_DIR="$FIRST_PARTY_CLT_DIR/bin"
readonly FIRST_PARTY_SHARE_DIR="$FIRST_PARTY_CLT_DIR/share"

# Other binaries and scripts
readonly THIRD_PARTY_CLT_DIR="$CLT_DIR/3rd-party-ad-hoc"
readonly THIRD_PARTY_BIN_DIR="$THIRD_PARTY_CLT_DIR/bin"
readonly THIRD_PARTY_SHARE_DIR="$THIRD_PARTY_CLT_DIR/share"

# The x86 user Homebrew instance directory
readonly HOMEBREW_X86_USER_DIR="$CLT_DIR/homebrew-x86"
# The arm64 user Homebrew instance directory
readonly HOMEBREW_ARM64_USER_DIR="$CLT_DIR/homebrew-arm64"

# We will link this path to the native user Homebrew instance
readonly HOMEBREW_NATIVE_USER_DIR="$CLT_DIR/homebrew"

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

# Python* (user) Homebrew instance. Should only have Python* installed, and the eggs installed with pip.
readonly HOMEBREW_PYTHON39_USER_DIR="$CLT_DIR/homebrew-python3.9"
readonly HOMEBREW_PYTHON38_USER_DIR="$CLT_DIR/homebrew-python3.8"
readonly HOMEBREW_PYTHON37_USER_DIR="$CLT_DIR/homebrew-python3.7"
readonly HOMEBREW_PYTHON27_USER_DIR="$CLT_DIR/homebrew-python2.7"

# Ruby (gem) Packages
readonly RUBY_DIR="$CLT_DIR/ruby"

# NPM Packages
readonly NPM_DIR="$CLT_DIR/npm"

# Go Packages
readonly GO_DIR="$CLT_DIR/go"

# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_SYSTEM_HOMEBREW_FORMULAE=(
	"cloc"                "bin/cloc"
	"coreutils"           "bin/gsort"
	"gti"                 "bin/gti"
	"htop"                "bin/htop"
	"jq"                  "bin/jq"
	"lftp"                "bin/lftp"
	"nmap"                "bin/nmap"
	"pass"                "bin/pass"
	"recode"              "bin/recode"
	"ruby"                "opt/ruby/bin/ruby"
	"rsync"               "bin/rsync"
	"speedtest-cli"       "bin/speedtest-cli"
	"the_silver_searcher" "bin/ag"
	"tmux"                "bin/tmux"
	"tree"                "bin/tree"
	"watch"               "bin/watch"
	"wget"                "bin/wget"
	"youtube-dl"          "bin/youtube-dl"
	
	"frizlab/perso/find-unreferenced-xcode-files" "bin/find-unreferenced-xcode-files"
	
	"mxcl/made/swift-sh" "bin/swift-sh"
	
	"happn-tech/public/locmapper" "Cellar/locmapper"
)
# The following formulae do not compile (et time of writing) on ARM macOS
# They should be in the MAIN_HOMEBREW_FORMULAE; in fine we’ll get rid of this
# variable as everything will work natively on ARM.
typeset -A X86_SYSTEM_HOMEBREW_FORMULAE=(
	"git-lfs"             "bin/git-lfs"
	"shellcheck"          "bin/shellcheck"
	"yq"                  "bin/yq"
)

# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_USER_HOMEBREW_FORMULAE=(
)

# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_USER_HOMEBREW_CASKS=(
	"frizlab/perso/my-web-quirks" "Caskroom/my-web-quirks"
	
	"happn-tech/public/base64"           "Caskroom/base64"
	"happn-tech/public/locmapper-app"    "Caskroom/locmapper-app"
	"happn-tech/public/locmapper-linter" "Caskroom/locmapper-linter"
)


# Sourcing env specific vars file
source "$SRC_FOLDER/vars-$COMPUTER_GROUP.zsh"
