### Install Homebrew ###
bin "frizlab" ":Darwin:Linux:" "bash/install-brew.sh"

### Set Sound Volume ###
bin "frizlab" ":Darwin:" "bash/set-sound-volume.sh"

### Get Mount Points ###
bin "frizlab" ":Darwin:" "bash/get-mount-points.sh"

### Is Desktop Picture ###
bin "frizlab" ":Darwin:" "sh/is-desktop-picture.sh"

### Is Valid JPEG ###
bin "frizlab" ":Darwin:" "sh/is-valid-jpeg.sh"

### Backup My Cloud ###
#  - name: "Backup My Cloud"
#    author: "frizlab"
#    compat: [MacOSX]
#    copy_instead_of_link: yes
#    bin_paths: ["bash/backup-cloud.sh"]

### abc to anything ###
bin "frizlab" ":Darwin:" "bash/abc2.sh"

### Get Text Encoding ###
bin "frizlab" ":Darwin:" "bin/get-text-encoding"

### Find Poured from Bottle Kegs in Homebrew ###
bin "frizlab" ":Darwin:Linux:" "swift/brew-find-poured-from-bottle.swift"

### Print ANSI Colors ###
bin "ian.abbott" ":Darwin:Linux:" "sh/ansi-colors.sh"

### abc2ps ###
# http://web.archive.org/web/20090507154446/http://www.ihp-ffo.de:80/~msm/
# http://web.archive.org/web/20100305171200/http://www.ihp-ffo.de/~msm/ReadMe.abc2ps
bin "michael.methfessel" ":Darwin:" "bin/abc2ps"

### abcppc ###
bin "frizlab" ":Darwin:" "bin/abcppc"

### abcm2pdf + runabc ###
bin "frizlab" ":Darwin:" "sh/abcm2pdf-runabc.sh"

### midi to abc ###
bin "<unknown>" ":Darwin:" "bin/midi2abc"

### Chronometer and Timer in TCL/TK ###
# Linux compat is untested, but there’s not reason why it wouldn’t work!
bin "frizlab" ":Darwin:Linux:" "tcl/chronodec.tk"

### Find Invalid Images ###
bin "frizlab" ":Darwin:" "bash/find-invalid-images.sh"

### Import to Photos ###
bin "frizlab" ":Darwin:" "bash/import-to-photos.sh"
doc "frizlab" ":Darwin:" "import-to-photos" "docs/import-to-photos.scpt"

### Learning bash arrays ###
# Linux compat is untested
bin "bbsteam" ":Darwin:Linux:" "bash/bash-arrays.sh"

### iOS Backup to Files ###
# Original author is unclear; see script for more info.
# Linux compat is untested
bin "frizlab" ":Darwin:Linux" "python2/ios-backup-to-files.py"

### ls mbdb ###
# Original author is unclear; but script comes from this stackoverflow question https://stackoverflow.com/questions/3085153.
# Linux compat is untested
bin "galloglass" ":Darwin:Linux" "python2/ls-mbdb.py"

### gem list leaves ###
# https://gist.github.com/astyagun/290b783045afffb8190a0c75ab76d0fa
# Linux compat is untested
bin "astyagun" ":Darwin:Linux:" "sh/gem-list-leaves.sh"

### Check iTunes Artworks ###
bin "frizlab" ":Darwin:" "bin/check-itunes-artworks"
doc "frizlab" ":Darwin:" "man/man1" "docs/check-itunes-artworks.1"

### srt to srt ###
bin "frizlab" ":Darwin:" "bin/srt2srt"

### Remove xattr ###
bin "frizlab" ":Darwin:" "bin/remove-xattr"
doc "frizlab" ":Darwin:" "man/man1" "docs/remove-xattr.1"

### Find Desktop Pictures ###
bin "frizlab" ":Darwin:" "bash/find-desktop-pictures.sh"

### Launch Alarm Clock ###
bin "frizlab" ":Darwin:" "bash/launch-alarm-clock.sh"

### Connect NetSoul ###
# This script was originally from someone else than frizlab, but so heavily modified that frizlab can take ownership.
# Linux compat is untested
bin "frizlab" ":Darwin:Linux:" "bash/connect-netsoul.sh"

### Persistent NetSoul ###
# Linux compat is untested
bin "frizlab" ":Darwin:Linux:" "bash/persistent-netsoul.sh"

### Fill Empty Directories ###
# Linux compat is untested
bin "frizlab" ":Darwin:Linux:" "sh/fill-empty-dirs.sh"

### Remove Quarantine ###
bin "frizlab" ":Darwin:" "sh/remove-quarantine.sh"

### Make Link ###
# This binary allows hard-linking directories. It’s dangerous, don’t do it! See https://stackoverflow.com/a/4707231 for more info.
bin "frizlab" ":Darwin:" "bin/make-link"
doc "frizlab" ":Darwin:" "man/man1" "docs/make-link.1"

### My Split ###
bin "frizlab" ":Darwin:" "bin/my-split"
