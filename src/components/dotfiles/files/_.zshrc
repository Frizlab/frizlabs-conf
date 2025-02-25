#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for interactive zsh shell.
# See <https://github.com/Frizlab/frizlabs-conf> for more info.

echo "ENTER: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"


# shellcheck source=_.shrc
# Let’s first include the non-standard non-zsh specific rc file.
# We disable the nomatch option for the time of the import because zsh does not behave the same as (ba)sh, and fails when the glob does not match anything.
# There might me more options to disable later.
{ test -r "${HOME}/.shrc" && (){ setopt localoptions; unsetopt nomatch; source "${HOME}/.shrc"; }; } || true


################################################################################
echo "START: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .zshrc:dyn first because of the variables we could reuse
{ test -r "${HOME}/.zshrc:dyn" && source "${HOME}/.zshrc:dyn"; } || true



# PS1, see bashrc for more info
__show_git_branch() {
	setopt pipefail; # Apparently there is no need for `setopt localoptions` here, though I’m not sure why.
	
	# We disable the check for iClouded repos as we do not need it anymore.
	if false; then
		# iCloud stuff.
		# We manually search for .git file or folder.
		# If we find it, we’re probably in a git repo.
		local iclouded=""
		local p="$PWD"
		local gitdir="$(realpath "$(git rev-parse --git-dir 2>/dev/null)" 2>/dev/null)"
		local gitroot="$(realpath "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)"
		# p should in theory always be absolute.
		# Let’s make sure of that (otherwise we have an infinite loop).
		if test "${p:0:1}" = "/" -a '(' -z "$gitdir" -o -z "$gitroot" ')'; then
			# git failed to find the top-level or git directory, so we search for it manually
			#  (some critical files from git dir might’ve been iclouded).
			while test -n "$p"; do
				if test -d "$p/.git"; then
					gitroot="$p"
					gitdir="$p/.git"
					p=
				elif test -f "$p/.git"; then
					gitroot="$p"
					gitdir="$(cd "$p"; echo "$(realpath "$(grep -E '^gitdir: ' ".git" 2>/dev/null | sed -E 's/^gitdir: //' 2>/dev/null)" 2>/dev/null)")"
					p=
				elif test -e "$p/..git.icloud"; then
					iclouded="y"
					p=
				else
					if test "$p" = "/"; then p=
					else                     p="$(dirname "$p")" || p=
					fi
				fi
			done
		fi
		
		if test "$iclouded" != "y" -a -n "$gitdir" -a -n "$gitroot"; then
			local -a to_search
			case "$gitdir" in
				"$gitroot"*) to_search=("$gitroot");;
				*)           to_search=("$gitdir" "$gitroot");;
			esac
			for d in "${to_search[@]}"; do
				# Try and search for matching files fast.
				# It’s not easy.
				# Best solution would be to have a cache.
				# For instance a daemon could run and monitor fsevents and write somewhere when a repo has some file being evicted.
				# Building on this, said tool could even give a nice GUI w/ list of repos and their current state.
				# This is all and nice but it requires some work, and thus some time, that I do not have.
				#
				# First fast solution was to use mdfind.
				# It is the perfect solution.
				# Except mdfind skips a lot of hidden files/folders…
				# For reference, the command: `mdfind -onlyin "$d" 'kMDItemFSName = *.icloud AND kMDItemFSInvisible = 1'`.
				# (The actual glob is '.*.icloud' but for whatever reason mdfind does not want to find files with full glob.)
				#
				# This having failed, I tried `searchfs`, which was a failure (did not find icloud files, and was not fast).
				#
				# Next up was `fd`.
				# Results were better than `find`.
				# Still not lightning fast, but I think it’ll be as good as I’ll get.
				# We fallback to find if `fd` fails (not installed for instance…).
				if test -n "$(fd -IHs1 '\..*\.icloud$' "$d" 2>/dev/null || find "$d" -type f -name ".*.icloud" -print -quit 2>/dev/null)"; then
					iclouded="y"
					break
				fi
			done
		fi
		
		if test "$iclouded" = "y"; then
			printf "[%%{\e[01;41m%%}iCloud%%{\e[0m%%}]"
			return
		fi
	fi
	
	# No need for more than 2 lines of status in theory as untracked are shown at the end.
	git_status="$(git status -b --porcelain 2>/dev/null | head -n 3)"
	git_status_ret=$?
	# Status 141 is 128 + 13 (13: SIGPIPE, 128: killed (IIUC)).
	if [ "$git_status_ret" -ne 0 -a "$git_status_ret" -ne 141 ]; then return; fi
	last_commit_msg="$(git log -1 --pretty="format:%B" 2>/dev/null || echo)"
	
	printf "[%%{\e[00;31m%%}"
	# Let’s parse the status to create the string to display.
	# Among other, we shorten the branch name and omit the upstream branch name if it is the same as the branch name.
	# We also add a star at the end of the string if there are modifications in the repo
	#  and a tilde if there are untracked files (and no other modifications).
	awk '
		# This:
		# - Replaces the "/frizlab/" part of a branch name by "/me/";
		# - Replaces the "feature/" part of a branch name by "feat/" (if the branch starts with this);
		# - Tries to shorten the branch name if possible/needed (currently not implemented).
		function process_branch_name(branch_name) {
			sub(/^feature\//, "feat/", branch_name)
			sub(/\/frizlab\//, "/me/", branch_name)
			# TODO: Find other ways of shortening a branch name if needed.
			return branch_name
		}
		
		BEGIN {
			found_diffs = 0
			found_untracked = 0
		}
		
		/^## / {
			# Remove the "## " prefix.
			branch_name_with_upstream = substr($0, 4)
			# We assume the whole string to be valid.
			# A valid branch name cannot contain "...", so if the string is found we have a branch name with an upstream.
			split_index = index(branch_name_with_upstream, "...")
			if (split_index == 0) {
				# No upstream, we just return the full string.
				printf "%s", process_branch_name(branch_name_with_upstream)
			} else {
				# Let’s retrieve the branch name and the upstream name.
				branch_name = substr(branch_name_with_upstream, 1, split_index - 1)
				upstream_with_info = substr(branch_name_with_upstream, split_index + 3)
				# Let’s split the upstream and the info.
				# We assume we have the expected format when a single space delimits the info and the upstream.
				split_index = index(upstream_with_info, " ")
				if (split_index > 0) {
					upstream = substr(upstream_with_info, 1, split_index - 1)
					info = substr(upstream_with_info, split_index)
				} else {
					upstream = upstream_with_info
					info = ""
				}
				# Now let’s find the remote name.
				split_index = index(upstream, "/")
				if (split_index == 0) {
					# Weird: we seem to have an upstream with an invalid name as it contains no "/".
					# Let’s bail and print the whole branch with the upstream.
					printf "%s%s", process_branch_name(branch_name_with_upstream), info
				} else {
					# We do have a slash in the upstream.
					# We do not check whether it’s non-empty or other validations as we do not care.
					upstream_name = substr(upstream, 1, split_index - 1)
					upstream_branch_name = substr(upstream, split_index + 1)
					if (branch_name == upstream_branch_name) {
						# The branch name is the same as the upstream branch name.
						# Let’s shorten the output.
						printf "%s...%s%s", process_branch_name(branch_name), upstream_name, info
					} else {
						# The names differ, we print the whole thing, but shorten the branch names.
						printf "%s...%s/%s%s", process_branch_name(branch_name), upstream_name, process_branch_name(upstream_branch_name), info
					}
				}
			}
		}
		
		/^[^#?]/ {found_diffs     = 1}
		/^\?/    {found_untracked = 1}
		
		END {
			if      (found_diffs     != 0) {printf "*"}
			else if (found_untracked != 0) {printf "~"}
		}
	' <<<"$git_status"
	{ test -z "$last_commit_msg" && printf " +nop" } || \
	{ test "$last_commit_msg" = "WIP" && printf " +wip" }
	printf "%%{\e[0m%%}]"
}
# We have to enable prompt substitutions for the git functions to work.
# We also set transientrprompt to remove RPS1 when the command has been accepted.
setopt promptsubst transientrprompt
# Emulate \# from bash: <https://superuser.com/a/696900>.
[[ $FRZ_ZSHPROMPT_CMD_COUNT -ge 1 ]] || FRZ_ZSHPROMPT_CMD_COUNT=1
preexec() { ((FRZ_ZSHPROMPT_CMD_COUNT++)) }
# Notes:
# There is probably a better way to handle the git prompt.
# I don’t care.
# \e is the same as \033.
# We could probably use %F and %B and co instead, but I did not find the same colors I was used to fast enough,
#  and found the %{%} solution to have the RPS1 correctly placed, so I did not search any further.
PS1=$'%{\e[01;36m%}$FRZ_ZSHPROMPT_CMD_COUNT%{\e[0m%} \\ %{\e[00;32m%}%D{%H:%M:%S}%{\e[0m%} / %{\e[00;33m%}%n@%m%{\e[0m%}[%{\e[00;31m%}%?%{\e[0m%}] %{\e[01;38m%}%~%{\e[0m%}`__show_git_branch`%) '
RPS1='%(0?.🤠🙃😃.😱😭😡)'; # Just to remember we’re using zsh

# We set EDITOR to vi in the profile, which changes the key bindings to vi instead of emacs.
# Let’s revert this.
bindkey -e
# We also want to have a more bash-style navigation (word navigation goes through words, not ’till the next space).
autoload -U select-word-style
select-word-style bash
# However, word suppression via ^W deletes the whole word backward, until next space, just like with bash too.
zle -N backward-kill-space-word backward-kill-word-match
zstyle :zle:backward-kill-space-word word-style space
bindkey '^W' backward-kill-space-word
# Also fix suppr key which does not work out of the box.
bindkey '^[[3~' delete-char

# Some zsh options we like.
# Mostly from there <https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/>.
#setopt nocaseglob; # To set globing to be case-insensitive (not set, we are on a cs fs)
setopt auto_cd; # Auto cd to directories without the need to add cd
setopt glob_complete; # Do not expand glob w/ tab (to be more bash-like)
setopt append_history; # Append to history instead of overwrite
setopt hist_ignore_dups hist_ignore_all_dups; # Ignore duplicates in history
setopt hist_reduce_blanks; # Remove blanks in history
setopt extended_history; # Also store timestamp in history
setopt hist_ignore_space; # Do not store commands starting with space (after next command)
setopt hist_no_store; # Do not store history and fc commands in history
#setopt correct correct_all; # Propose correction for incorrect commands in Terminal; disabled because I don’t like it.
if test "$(uname -s)" != "Darwin"; then
	# Add to history incrementally instead of when shell quits.
	# Not enabled on macOS because it disables state restoration.
	setopt inc_append_history
fi

# Search through history when something is typed.
# Disabled because it’s more annoying than helpful (I use ctrl-R to search through history).
#bindkey '^[[A' up-line-or-search
#bindkey '^[[B' down-line-or-search

# Edit command line for ^X^E.
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Convenient alias for macOS.
alias h='cat ~/.zsh_sessions/*.history*'



### Let’s import .zshrc.d/*.sh files
for f in "${HOME}/.zshrc.d"/*.sh(N); do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


echo "EXIT: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
