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
#readonly HOMEBREW_PYTHON3_DIR="$CLT_DIR/homebrew-python3"
# Python2 Homebrew instance. This instance should only have Python 2 installed,
# and Python2 eggs installed with pip. This directory is not in the path. There
# will only be the python2 (and related such as pip2) available as aliases.
#readonly HOMEBREW_PYTHON2_DIR="$CLT_DIR/homebrew-python2"

# Ruby (gem) Packages
readonly RUBY_DIR="$CLT_DIR/ruby"

# NPM Packages
readonly NPM_DIR="$CLT_DIR/npm"

# Go Packages
readonly GO_DIR="$CLT_DIR/go"

source "$SRC_FOLDER/vars-$COMPUTER_GROUP.zsh"
