#!/bin/bash

version() {
	echo "xcode-project-version-manager.sh 1.0 by François Lamboley <lamboley.francois@me.com> http://www.frostland.fr/"
	echo "  Inspired by https://gist.github.com/1089407 (Joachim Bondo)"
	# However, the original script gets the version number from git tags,
	# this version does not deal with git tags (tagging must be done externally)
	# Another change: this script is not intended to be a build phase in Xcode
}

usage() {
	version >&2
	cat << EOF >&2

Manages build and version numbers using git and agvtool.

Usage:
  $(basename "$0") [options]

Options:
  -y, --yes                      Always answer yes to questions
  -b, --bump                     Bumps the Build Version and commits. If status was
                                 not clean, asks before continuing
  -c, --create-release <version> Sets the marketing version of your projects and commits.
                                 If status was not clean, asks before continuing
  -g, --edit-git-msg             Gives the opportunity to edit the git commit message
  -h, --help                     Displays this help text
  -v, --version                  Displays script version number
EOF
}

function warn_to_continue() {
	read -p "${1}Do you want to continue? (y for yes, anything else for no) " -n 2 f
	while [ "$f" != "" -a $(echo "$f" | wc -c) -gt 2 ]; do read -n 2 f; done
	if [ "$f" = "y" ]; then return 0; else return 1; fi
}

function is_xcode_running() {
	product_name_backslashed="$(echo "$product_name" | sed -E 's/"/\\"/g')"
	return $(osascript -e 'tell application "System Events"
		if ((name of every process) contains "Xcode") then
			tell application "Xcode"
				repeat with doc in workspace documents
					if (name of doc as text) starts with "'$product_name_backslashed'.xcodeproj/" then
						return 0
					end if
				end repeat
			end tell
			return 1
		else
			return 1
		end if
	end tell')
}

function check_git_clean() {
	st_count=$(git status --porcelain | grep -vE '^\?\?' | wc -l 2>/dev/null)
	
	if [ $? -ne 0 -o $st_count -ne 0 ]; then return 1; else return 0; fi
}

bump() {
	should_continue=1
	if [ $should_answer_yes -eq 0 -a "$(is_xcode_running && echo "ok")" = "ok" ]; then warn_to_continue "Xcode is running. " || should_continue=0; fi
	if [ $should_continue -eq 0 ]; then return 1; fi
	if [ $should_answer_yes -eq 0 -a "$(check_git_clean && echo "ok")" != "ok" ]; then warn_to_continue "git repo is dirty. " || should_continue=0; fi
	if [ $should_continue -eq 0 ]; then return 1; fi

	agvtool bump -all &>/dev/null
	if [ $? -ne 0 ]; then echo "*** Error: Bumping Build Version failed." >&2; return 2; fi
	new_version=$(agvtool what-version -terse)
	echo "Bumped build number to: ${new_version}"

	git commit -am "xcode-project-version-manager: Build Version bumped to $new_version" $git_flags
}

function create_release() {
	new_version="$1"
	should_continue=1
	if [ $should_answer_yes -eq 0 -a "$(is_xcode_running && echo "ok")" = "ok" ]; then warn_to_continue "Xcode is running. " || should_continue=0; fi
	if [ $should_continue -eq 0 ]; then return 1; fi
	if [ $should_answer_yes -eq 0 -a "$(check_git_clean && echo "ok")" != "ok" ]; then warn_to_continue "git repo is dirty. " || should_continue=0; fi
	if [ $should_continue -eq 0 ]; then return 1; fi

	agvtool new-marketing-version "$new_version" &> /dev/null
	if [ $? -ne 0 ]; then echo "*** Error: Setting version to $new_version failed." >&2; return 2; fi
	new_version=$(agvtool what-marketing-version -terse1)
	git commit -am "xcode-project-version-manager: Marketing Version set to $new_version" $git_flags
}

# Set default values.
action=usage
git_flags=
should_answer_yes=0
# The last Xcode project alphabetically wins...
for f in *.xcodeproj; do product_name="$(basename "$f" .xcodeproj)"; done

# Parse command line options.
while [ $# -gt 0 ]; do
	# Check parameters.
	case $1 in
		-c | --create-release )
			new_version=$2
			action="create_release $new_version"
			if [ "$new_version" = "" ]; then usage; exit 1; fi
			shift;;
		-g | --edit-git-msg )
			git_flags="$git_flags -e"
			;;
		-b | --bump )
			action=bump
			;;
		-y | --yes )
			should_answer_yes=1
			;;
		-h | --help )
			usage
			exit 1;;
		-v | --version )
			version
			exit 1;;
		* ) # Unknown option
			echo "Error: Unknown option '$1'" 1>&2
			usage
			exit 1;;
	esac	
	shift
done

$action
