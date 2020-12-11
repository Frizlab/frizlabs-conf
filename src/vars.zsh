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

# Main Homebrew instance directory
readonly HOMEBREW_DIR="$CLT_DIR/homebrew"
# The x86 Homebrew instance directory; only installed on macOS ARM
readonly HOMEBREW_X86_DIR="$CLT_DIR/homebrew-x86"
# Python3.9 Homebrew instance. Should only have Python3.9 installed, and the eggs installed with pip.
readonly HOMEBREW_PYTHON39_DIR="$CLT_DIR/homebrew-python3.9"
# Python 3.8 does not compile (yet?) w/ Homebrew on macOS 11
#readonly HOMEBREW_PYTHON38_DIR="$CLT_DIR/homebrew-python3.8"

# Ruby (gem) Packages
readonly RUBY_DIR="$CLT_DIR/ruby"

# NPM Packages
readonly NPM_DIR="$CLT_DIR/npm"

# Go Packages
readonly GO_DIR="$CLT_DIR/go"

# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_HOMEBREW_FORMULAE=(
	"cloc"                "bin/cloc"
	"coreutils"           "bin/gsed"
	"gti"                 "bin/gti"
	"htop"                "bin/htop"
	"jq"                  "bin/jq"
	"lftp"                "bin/lftp"
	"nmap"                "bin/nmap"
	"recode"              "bin/recode"
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
typeset -A X86_HOMEBREW_FORMULAE=(
	"git-lfs"             "bin/git-lfs"
	"pass"                "bin/pass"
	"shellcheck"          "bin/shellcheck"
	"yq"                  "bin/yq"
)
# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_HOMEBREW_CASKS=(
	"frizlab/perso/my-web-quirks" "$HOME/Applications/My Web Quirks.app"
	
	"happn-tech/public/base64"           "$HOME/Applications/base64.app"
	"happn-tech/public/locmapper-app"    "$HOME/Applications/LocMapper.app"
	"happn-tech/public/locmapper-linter" "$HOME/Applications/LocMapper Linter.app"
)


# Sourcing env specific vars file
source "$SRC_FOLDER/vars-$COMPUTER_GROUP.zsh"
