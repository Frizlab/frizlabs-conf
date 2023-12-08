# Not -r because we modify this variable in the env specific vars file
typeset -A PKGS_BREW_SYSTEM__MAIN_FORMULAE=(
	"cloc"                "bin/cloc"
	"coreutils"           "bin/gsort"
	"fd"                  "bin/fd"
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
	"swift-outdated"      "bin/swift-outdated"
	"tcl-tk"              "opt/tcl-tk/bin/tclsh"
	"terminal-notifier"   "bin/terminal-notifier"
	"the_silver_searcher" "bin/ag"
	"tmux"                "bin/tmux"
	"trash"               "bin/trash"
	"tree"                "bin/tree"
	"watch"               "bin/watch"
	"wget"                "bin/wget"
	"youtube-dl"          "bin/youtube-dl"
)
if test "$HOST_OS" != "Linux"; then
	# These formulae do not compile on Linux (at the time of writing), so we only add them when we’re not on Linux.
	PKGS_BREW_SYSTEM__MAIN_FORMULAE+=(
		# Plain patch error when trying to install bottle; probably fixed soon
		"recode"              "bin/recode"
		
		# Needs Swift.
		# I could `brew install swift`, but it’s expensive, probably (probably because I tried and it failed).
		"frizlab/perso/find-unreferenced-xcode-files" "bin/find-unreferenced-xcode-files"
		"frizlab/perso/locmapper"                     "bin/locmapper"
		"xcode-actions/tap/xct"                       "bin/xct"
		"mxcl/made/swift-sh"                          "bin/swift-sh"
	)
fi

# The following formulae do not compile (at the time of writing) on ARM macOS.
# They should be in the MAIN_HOMEBREW_FORMULAE; in fine we’ll get rid of this variable as everything will work natively on ARM.
typeset -A PKGS_BREW_SYSTEM__X86_FORMULAE=(
)

# Not -r because we modify this variable in the env specific vars file.
typeset -A PKGS_BREW_SYSTEM__CASKS=(
	"appcleaner" "Caskroom/appcleaner" # And **NOT** app-cleaner!
)


# Sourcing env specific vars file
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true
