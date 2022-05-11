### Dump Safari Tabs to stdout ###
bin_task__wrapped_bin "frizlab" ":Darwin:" "sh/dump-safari-tabs.sh"

### Run a Shell Command When a File Changes ###
bin_task__bin "frizlab" ":Darwin:" "swift-sh/run-on-change.swift"

### Backup My Cloud ###
bin_task__encrypted_bin "frizlab" ":Darwin:~work~server~vm~" "bash/backup-cloud.sh.cpt"

### Backup the Stuff I Can’t Live Without ###
bin_task__encrypted_bin "frizlab" ":Darwin:~work~server~vm~" "bash/backup-precious-stuff.sh.cpt"

### Backup the Main Computer ###
bin_task__encrypted_bin "frizlab" ":Darwin:~work~server~vm~" "zsh/backup-main-computer.sh.cpt"

### Clone Media HD ###
bin_task__encrypted_bin "frizlab" ":Darwin:~work~server~vm~" "zsh/clone-media-hd.sh.cpt"

### Backup All Repos In a Given GitHub Org ###
# Linux compat is untested, but there’s not reason why it wouldn’t work
bin_task__bin "frizlab" ":Darwin:Linux:~work~" "bash/backup-github-org.sh"

### Install Homebrew ###
bin_task__bin "frizlab" ":Darwin:Linux:" "bash/install-brew.sh"

### Set Sound Volume ###
bin_task__bin "frizlab" ":Darwin:" "bash/set-sound-volume.sh"

### Get Mount Points ###
bin_task__bin "frizlab" ":Darwin:" "bash/get-mount-points.sh"

### Is Desktop Picture ###
bin_task__bin "frizlab" ":Darwin:" "sh/is-desktop-picture.sh"

### Is Valid JPEG ###
bin_task__bin "frizlab" ":Darwin:" "sh/is-valid-jpeg.sh"

### abc to anything ###
bin_task__bin "frizlab" ":Darwin:" "bash/abc2.sh"

### Get Text Encoding ###
bin_task__bin "frizlab" ":Darwin:" "bin/get-text-encoding"

### Find Poured from Bottle Kegs in Homebrew ###
bin_task__bin "frizlab" ":Darwin:Linux:" "swift/brew-find-poured-from-bottle.swift"

### Print ANSI Colors ###
bin_task__bin "ian.abbott" ":Darwin:Linux:" "sh/ansi-colors.sh"

### abc2ps ###
# http://web.archive.org/web/20090507154446/http://www.ihp-ffo.de:80/~msm/
# http://web.archive.org/web/20100305171200/http://www.ihp-ffo.de/~msm/ReadMe.abc2ps
bin_task__bin "michael.methfessel" ":Darwin:" "bin/abc2ps"

### abcppc ###
bin_task__bin "frizlab" ":Darwin:" "bin/abcppc"

### abcm2pdf + runabc ###
bin_task__bin "frizlab" ":Darwin:" "sh/abcm2pdf-runabc.sh"

### midi to abc ###
bin_task__bin "<unknown>" ":Darwin:" "bin/midi2abc"

### Chronometer and Timer in TCL/TK ###
# Linux compat is untested, but there’s not reason why it wouldn’t work
bin_task__bin "frizlab" ":Darwin:Linux:" "tcl/chronodec.tk"

### Find Invalid Images ###
bin_task__bin "frizlab" ":Darwin:" "bash/find-invalid-images.sh"

### Import to Photos ###
bin_task__bin "frizlab" ":Darwin:~work~server~" "bash/import-to-photos.sh"
bin_task__doc "frizlab" ":Darwin:~work~server~" "import-to-photos" "docs/import-to-photos.scpt"

### Learning bash arrays ###
# Linux compat is untested
bin_task__bin "bbsteam" ":Darwin:Linux:" "bash/bash-arrays.sh"

### iOS Backup to Files ###
# Original author is unclear; see script for more info.
# Linux compat is untested
bin_task__bin "frizlab" ":Darwin:Linux:" "python2/ios-backup-to-files.py"

### ls mbdb ###
# Original author is unclear; but script comes from this stackoverflow question https://stackoverflow.com/questions/3085153.
# Linux compat is untested
bin_task__bin "galloglass" ":Darwin:Linux:" "python2/ls-mbdb.py"

### gem list leaves ###
# https://gist.github.com/astyagun/290b783045afffb8190a0c75ab76d0fa
# Linux compat is untested
bin_task__bin "astyagun" ":Darwin:Linux:" "sh/gem-list-leaves.sh"

### Check iTunes Artworks ###
bin_task__bin "frizlab" ":Darwin:" "bin/check-itunes-artworks"
bin_task__doc "frizlab" ":Darwin:" "man/man1" "docs/check-itunes-artworks.1"

### srt to srt ###
bin_task__bin "frizlab" ":Darwin:" "bin/srt2srt"

### Remove xattr ###
bin_task__bin "frizlab" ":Darwin:" "bin/remove-xattr"
bin_task__doc "frizlab" ":Darwin:" "man/man1" "docs/remove-xattr.1"

### Find Desktop Pictures ###
bin_task__bin "frizlab" ":Darwin:" "bash/find-desktop-pictures.sh"

### Launch Alarm Clock ###
bin_task__bin "frizlab" ":Darwin:~work~server~" "bash/launch-alarm-clock.sh"

### Connect NetSoul ###
# This script was originally from someone else than frizlab, but so heavily modified that frizlab can take ownership.
# Linux compat is untested
bin_task__bin "frizlab" ":Darwin:Linux:" "bash/connect-netsoul.sh"

### Persistent NetSoul ###
# Linux compat is untested
bin_task__bin "frizlab" ":Darwin:Linux:" "bash/persistent-netsoul.sh"

### Fill Empty Directories ###
# Linux compat is untested
bin_task__bin "frizlab" ":Darwin:Linux:" "sh/fill-empty-dirs.sh"

### Remove Quarantine ###
bin_task__bin "frizlab" ":Darwin:" "sh/remove-quarantine.sh"

### Make Link ###
# This binary allows hard-linking directories. It’s dangerous, don’t do it! See https://stackoverflow.com/a/4707231 for more info.
bin_task__bin "frizlab" ":Darwin:~work~" "bin/make-link"
bin_task__doc "frizlab" ":Darwin:~work~" "man/man1" "docs/make-link.1"

### My Split ###
bin_task__bin "frizlab" ":Darwin:~work~" "bin/my-split"


### compopt ###
# When compopt is not available (e.g. w/ Bash 3), this hides the error we get from some completion scripts that use compopt.
dest="$THIRD_PARTY_BIN_DIR/compopt"
backup_dir="$THIRD_PARTY_BIN_DIR/$BIN__BACKUP_DIR_BASENAME"
start_task "link fake compopt -> ${dest/#$HOME/\~}"
src=
run_and_log test -x "$src" || src="/usr/bin/true"                              || true
run_and_log test -x "$src" || src="/bin/true"                                  || true
run_and_log test -x "$src" || src="$(run_and_log_keep_stdout command -v true)" || true
run_and_log test -x "$src" || src="$(run_and_log_keep_stdout which true)"      || true
run_and_log test -x "$src" || { log_task_failure "cannot get path of bin “true”."; RES="failed"; RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libfiles__folder "$backup_dir" "$BIN__BACKUP_DIR_MODE" && RES_LIST+=("$RES") }
{ res_check "$RES" &&   catchout RES  libfiles__linknbk "$src" "$dest" "755" "$backup_dir"   && RES_LIST+=("$RES") }
log_task_from_res_list RES_LIST
