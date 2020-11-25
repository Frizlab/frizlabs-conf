#!/bin/sh
# List Ruby gems, that are not a dependency of any other gem (analog of `brew leaves`)
# https://gist.github.com/astyagun/290b783045afffb8190a0c75ab76d0fa

GEM="${HOME}/usr/homebrew/bin/gem"

GEMS_FILE=`mktemp`
DEPENDENCIES_FILE=`mktemp`

"$GEM" list -l | sed 's/ (.*//' | sort >"$GEMS_FILE"
cat "$GEMS_FILE" | xargs -n1 "$GEM" dependency -l --pipe | sed 's/ --version.*//' | sort -u >"$DEPENDENCIES_FILE"
comm -23 "$GEMS_FILE" "$DEPENDENCIES_FILE"
rm -f "$GEMS_FILE $DEPENDENCIES_FILE"
