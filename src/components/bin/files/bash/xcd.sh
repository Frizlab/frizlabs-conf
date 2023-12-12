#!/bin/bash
set -euo pipefail



readonly MODE="$1"; shift

case "$MODE" in
	"pro")
		quit-xcode-gently
		defaults write com.apple.dt.Xcode DVTTextIndentWidth -int 4
		defaults write com.apple.dt.Xcode DVTTextIndentCase -bool no
		defaults write com.apple.dt.Xcode DVTTextIndentUsingTabs -bool no
		;;
	
	"perso")
		quit-xcode-gently
		defaults write com.apple.dt.Xcode DVTTextIndentWidth -int 3
		defaults write com.apple.dt.Xcode DVTTextIndentCase -bool yes
		defaults write com.apple.dt.Xcode DVTTextIndentUsingTabs -bool yes
		;;
	
	*)
		echo "unknown mode" >/dev/stderr
		exit 1
		;;
esac
