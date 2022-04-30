# The Applications directory.
readonly APP_DIR="$HOME/Applications"

# The CLT (Command-Line Tools) directory.
readonly CLT_DIR="$HOME/clt"

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

# The CLT directory for launchd scripts.
# This contains scripts that are executed by launchd:
# starting with Catalina sh does not have permission to read files in the user’s Documents folder (and some others), so we have to put them in another folder…
readonly LAUNCHD_CLT_BIN_DIR="$CLT_DIR/launchd-scripts"

# The x86 user Homebrew instance directory
readonly HOMEBREW_X86_USER_DIR="$CLT_DIR/homebrew-x86"
# The arm64 user Homebrew instance directory
readonly HOMEBREW_ARM64_USER_DIR="$CLT_DIR/homebrew-arm64"

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

# Ruby (gem) Packages
readonly RUBY_DIR="$CLT_DIR/ruby"

# NPM Packages
readonly NPM_DIR="$CLT_DIR/npm"

# Go Packages
readonly GO_DIR="$CLT_DIR/go"

# Not -r because we modify this variable in the env specific vars file
typeset -a COMPONENTS=(
	"core"
	"dotfiles"
	"bin"
	"launchd"
	"defaults"
)

# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_SYSTEM_HOMEBREW_FORMULAE=(
	"cloc"                "bin/cloc"
	"coreutils"           "bin/gsort"
	"git-lfs"             "bin/git-lfs"
	"gti"                 "bin/gti"
	"htop"                "bin/htop"
	"jq"                  "bin/jq"
	"just"                "bin/just"
	"lftp"                "bin/lftp"
	"nmap"                "bin/nmap"
	"p7zip"               "bin/7z"
	"pass"                "bin/pass"
	"pstree"              "bin/pstree"
	"python3"             "bin/python3"
	"ruby"                "opt/ruby/bin/ruby"
	"rsync"               "bin/rsync"
	"speedtest-cli"       "bin/speedtest-cli"
	"shellcheck"          "bin/shellcheck"
	"swift-format"        "bin/swift-format"
	"terminal-notifier"   "bin/terminal-notifier"
	"the_silver_searcher" "bin/ag"
	"tmux"                "bin/tmux"
	"tree"                "bin/tree"
	"watch"               "bin/watch"
	"wget"                "bin/wget"
	"youtube-dl"          "bin/youtube-dl"
)
if test "$HOST_OS" != "Linux"; then
	# These formulae do not compile on Linux (at the time of writing), so we only add them when we’re not on Linux.
	MAIN_SYSTEM_HOMEBREW_FORMULAE+=(
		# Plain patch error when trying to install bottle; probably fixed soon
		"recode"              "bin/recode"
		
		# Needs Swift.
		# I could `brew install swift`, but it’s expensive, probably (probably because I tried and it failed).
		"frizlab/perso/find-unreferenced-xcode-files" "bin/find-unreferenced-xcode-files"
		"xcode-actions/tap/xct"                       "bin/xct"
		"swiftdocorg/formulae/swift-doc"              "bin/swift-doc"
		"mxcl/made/swift-sh"                          "bin/swift-sh"
		"happn-app/public/locmapper"                  "Cellar/locmapper"
	)
fi
# The following formulae do not compile (at the time of writing) on ARM macOS.
# They should be in the MAIN_HOMEBREW_FORMULAE; in fine we’ll get rid of this variable as everything will work natively on ARM.
typeset -A X86_SYSTEM_HOMEBREW_FORMULAE=(
)

# Not -r because we modify this variable in the env specific vars file.
typeset -A MAIN_SYSTEM_HOMEBREW_CASKS=(
)

# Not -r because we modify this variable in the env specific vars file.
typeset -A MAIN_USER_HOMEBREW_FORMULAE=(
)

# Not -r because we modify this variable in the env specific vars file.
typeset -A MAIN_USER_HOMEBREW_CASKS=(
	"appcleaner"    "Caskroom/appcleaner" # And **NOT** app-cleaner!
	"brave-browser" "Caskroom/brave-browser"
	"chalk"         "Caskroom/chalk"
	"dash"          "Caskroom/dash"
	"hex-fiend"     "Caskroom/hex-fiend"
	"imageoptim"    "Caskroom/imageoptim"
	"netnewswire"   "Caskroom/netnewswire"
	
	"frizlab/perso/my-web-quirks" "Caskroom/my-web-quirks"
	
	"happn-app/public/base64"           "Caskroom/base64"
	"happn-app/public/locmapper-app"    "Caskroom/locmapper-app"
	"happn-app/public/locmapper-linter" "Caskroom/locmapper-linter"
)


# Sourcing env specific vars file
source "$SRC_FOLDER/vars-$COMPUTER_GROUP.zsh"
