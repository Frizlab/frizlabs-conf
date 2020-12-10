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
# Python3 Homebrew instance. This instance should only have Python 3 installed,
# and Python3 eggs installed with pip. This directory is not in the path. There
# will only be the python3 (and related such as pip3) available as aliases. As
# Python3 is the current Python, python by itself will also point to this.
readonly HOMEBREW_PYTHON3_DIR="$CLT_DIR/homebrew-python3"
# Python2 Homebrew instance. This instance should only have Python 2 installed,
# and Python2 eggs installed with pip. This directory is not in the path. There
# will only be the python2 (and related such as pip2) available as aliases.
readonly HOMEBREW_PYTHON2_DIR="$CLT_DIR/homebrew-python2"

# Ruby (gem) Packages
readonly RUBY_DIR="$CLT_DIR/ruby"

# NPM Packages
readonly NPM_DIR="$CLT_DIR/npm"

# Go Packages
readonly GO_DIR="$CLT_DIR/go"

# Not -r because we modify this variable in the env specific vars file
typeset -A MAIN_HOMEBREW_PACKAGES
### Formulae ###
MAIN_HOMEBREW_PACKAGES+=(
	"cloc"                "bin/cloc"
	"coreutils"           "bin/gsed"
	"git-lfs"             "bin/git-lfs"
	"gti"                 "bin/gti"
	"htop"                "bin/htop"
	"jq"                  "bin/jq"
	"lftp"                "bin/lftp"
	"nmap"                "bin/nmap"
	"pass"                "bin/pass"
	"recode"              "bin/recode"
	"rsync"               "bin/rsync"
	"shellcheck"          "bin/shellcheck"
	"speedtest-cli"       "bin/speedtest-cli"
	"the_silver_searcher" "bin/ag"
	"tmux"                "bin/tmux"
	"watch"               "bin/watch"
	"wget"                "bin/wget"
	"youtube-dl"          "bin/youtube-dl"
	"yq"                  "bin/yq"
	
	"frizlab/perso/find-unreferenced-xcode-files" "bin/find-unreferenced-xcode-files"
	
	"mxcl/made/swift-sh" "bin/swift-sh"
	
	"happn-tech/public/locmapper" "Cellar/locmapper"
)
### Casks ###
MAIN_HOMEBREW_PACKAGES+=(
	"frizlab/perso/my-web-quirks" "$HOME/Applications/My Web Quirks.app"
	"happn-tech/public/base64"    "$HOME/Applications/base64.app"
)


# Sourcing env specific vars file
source "$SRC_FOLDER/vars-$COMPUTER_GROUP.zsh"
