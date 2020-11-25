#!/bin/sh

cd ~/Library/Preferences/tmp

base=$(basename $1 "")

format=$HOME/Documents/_en_cours/musique/abc/formats/a4_s750.fmt
nom_s=apprentissage.pdf

abc2 -pdf + -abcoptions "-F $format" -noop -- $base
gv X.tmp.ps
mv X.tmp.pdf $nom_s
mv $nom_s /Users/francois/Documents/_en_cours/musique/abc/pdf/

exit
