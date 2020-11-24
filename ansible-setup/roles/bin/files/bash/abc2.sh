#!/bin/bash

# Pour retenir comment faire un tableau en shell (inutile dans ce programme)
# Only works with bash 4 or more
#nfile=0
#while [ $# -ne 0 ] ; do
#	listefile[$nfile]=$1
#	echo ${listefile[$nfile]}
#	nfile=$(($nfile+1))
#	shift
#done

if [ ! "$(type -p abcppc)" ] ; then
	echo "Can't run without abcppc installed"
	exit 3
fi

Usage () {
	progname="$(basename -- "$1")"
	echo "Usage : $progname options ??--?? file1 ??file2 file3...??
   Options:
      -ppc (+ | - | m) : permet de creer un nouveau fichier abc traduit par un preprocesseur
                         le \"+\" permet de dire que l'on veut de l'abc+ en sortie
                         le \"-\" impose de l'abc standard et le \"m\", de l'abc
                         pour abc2midi. C'est vous qui dites ce que vous voulez
                         pour chaque format. Pour cela, il vous faut entourer ce que
                         vous voulez seulement en abc+ de \"\$\$\", en abc standard de \"@@\"
                         et en abc pour abc2midi, de \"&&\".
      -abc (+ | - | m) : permet de creer un nouveau fichier abc traduit par abc2abc.
                         Le preprocesseur est evidemment passe avant de donner le fichier
                         a abc2abc.
      -ps (+ | -) : cree un fichier postscript avec abcm2ps pour le + et abc2ps pour le -.
                    Le preprocesseur est toujours passe (voir l'option \"-ppc\").
      -pdf (+ | -) : idem \"-ps\" avec en plus la creation d'un pdf par pstopdf.
      -kps : permet de garder le postscript lorsque l'option -pdf est utilisee.
      -midi : cree un fichier midi avec abc2midi. Les substitutions expliquees dans l'option
              \"-ppc\" sont toujours appliquees.
      -ofc : permet d'ouvrir le fichier qui a ete utilise pour la compilation.
             Si cette option n'est pas definie, le fichier est supprime.
      -oe : pour ouvrir le fichier utilise pour la compilation en cas d'erreur.
            Ne marche que pour abcm2ps.
      -abcoptions 'options abc...' : options d'abc a passer a l'executable qui va compiler
                                     les fichiers abc (les simples quotes sont obligatoires).
      -abcfileoptions 'options de fichier d'abcm2ps...' :
         options de fichiers pour abcm2ps qui differencie les options du programme et les
         options de fichiers ! Ici aussi, vous devez mettre les simples quotes.
      -nusedfopts :
         permet de ne pas ajouter les options dont je me sert le plus souvent
         aux options que vous choisissez. Ces options sont :
            pour abc2abc : rien
            pour abc2midi : rien
            pour abc2ps  : '-o -O = -maxv 20 -k 1 -N' (sans \"-o\", abc2ps ne fais
                                   qu'afficher les caracteristiques du morceau)
            pour abcm2ps : '-N 3 -c -j 5'
         Et pour les options de fichiers d'abcm2ps '-O='
      -outdir dir : defini le dossier de sortie des fichiers crees. dir ne doit pas
                    forcement exister : il est cree a la volee s'il n'existe pas.
                    Si cette option n'est pas definie, c'est le dossier courant qui est choisi
      -op : pour ouvrir les fichiers crees automatiquement.
      
   ATTENTION, si vous definissez plusieurs fois la meme options, c'est la derniere
   qui sera prise en compte (par exemple avec \"$progname -abc + -pdf - -- file\",
   le format de sortie de \"file\" sera du pdf converti avec abc2ps).
   
   Par defaut, le fichier est converti en pdf avec abcm2ps et le postscript est supprime."
}

isValidMode () {
	if [ "$whatisit" = "ppc" -o "$whatisit" = "abc" ] ; then
		if [ "$1" = "+" -o  "$1" = "-" -o  "$1" = "m" ] ; then
			echo 1
		else
			echo 0
		fi
	else
		if [ "$1" = "+" -o  "$1" = "-" ] ; then
			echo 1
		else
			echo 0
		fi
	fi
}

whatisit=pdf
mode=+
deleteps=1
openfilecompile=0
abcoptions=
abcfileoptions=
openonerror=0
outdir="$(pwd)"
openfile=0
usedfopts=1

optionsfinished=0
while [ $# -ne 0 ] ; do
	case "$1" in
		-ppc)
			shift
			whatisit=ppc
			mode="$1"
			if [ $(isValidMode "$mode") -eq 0 ] ; then
				echo "invalid mode \"$mode\"" >/dev/stderr
				exit 1
			fi
			;;
		-abc)
			shift
			whatisit=abc
			mode="$1"
			if [ $(isValidMode "$mode") -eq 0 ] ; then
				echo "invalid mode \"$mode\"" >/dev/stderr
				exit 1
			fi
			;;
		-ps)
			shift
			whatisit=pst
			mode="$1"
			if [ $(isValidMode "$mode") -eq 0 ] ; then
				echo "invalid mode \"$mode\"" >/dev/stderr
				exit 1
			fi
			;;
		-pdf)
			shift
			whatisit=pdf
			mode="$1"
			if [ $(isValidMode "$mode") -eq 0 ] ; then
				echo "invalid mode \"$mode\"" >/dev/stderr
				exit 1
			fi
			;;
		-kps)
			deleteps=0
			;;
		-midi)
			whatisit=midi
			mode=m
			;;
		-ofc)
			openfilecompile=1
			;;
		-abcoptions)
			shift
			abcoptions="$1"
			;;
		-abcfileoptions)
			shift
			abcfileoptions="$1"
			;;
		-oe)
			openonerror=1
			;;
		-outdir)
			shift
			outdir="$1"
			;;
		-op)
			openfile=1
			;;
		-nusedfopts)
			usedfopts=0
			;;
		--)
			if [ $optionsfinished -ne 0 ] ; then
				Usage "$0"
				exit 1
			fi
			shift
			break
			;;
		[^-]*)
			# here, there is the files
			optionsfinished=1
			break
			;;
		-h)
			Usage "$0"
			exit 0
			;;
		--help)
			Usage "$0"
			exit 0
			;;
		-*)
			echo "Invalid option : $1"
			Usage $0
			exit 1
			;;
	esac
	shift
done

if [ ! "$1" ] ; then
	echo "Vous devez mettre un nom de ficher apres les options" >/dev/stderr
	exit 1
fi

# Set default options
if [ $usedfopts -eq 1 ] ; then
	case "$whatisit" in
		ppc)
			;;
		abc)
			;;
		midi)
			;;
		pst|pdf)
			case "$mode" in
				+)
					abcoptions="-N 3 -c -j 5 $abcoptions"
					abcfileoptions="-O= $abcfileoptions"
					;;
				-)
					abcoptions="-o -O = -maxv 20 -k 1 -N $abcoptions"
					;;
				*)
					echo "Bug interne dans l'ajout des options du main (le mode choisi n'existe pas)" >/dev/stderr
					exit 2
					;;
			esac
			;;
		*)
			echo "Bug interne dans l'ajout des options du main (la sortie choisi n'existe pas)" >/dev/stderr
			exit 2
			;;
	esac
fi

ppc() {
	filetoconvertppc="$1"
	base="$(basename -- "$filetoconvertppc" .abc)"
	currentdirppc="$(pwd)"
	cd "$2"
	case "$mode" in
		+)
			namenewfile="$base.abc+"
			abcppc '$@&' "$filetoconvertppc" "$namenewfile"
			;;
		-)
			namenewfile="$base.abc-"
			abcppc '@&$' "$filetoconvertppc" "$namenewfile"
			;;
		m)
			namenewfile="$base.abcmid"
			abcppc '&$@' "$filetoconvertppc" "$namenewfile"
			;;
		*)
			echo "Bug interne dans la fonction ppc (le mode choisi n'existe pas)" >/dev/stderr
			exit 2
			;;
	esac
	
	intername="$namenewfile\_$$"
	sed -e '/^$/ d' \
		 -e 's/^X[ \t]*:[ \t]*\([0-9][0-9]*\)$/\
X: \1/g' "$namenewfile" > "$intername"
	mv "$intername" "$namenewfile"
	if [ $openfile -eq 1 -a "$whatisit" = "ppc" ] ; then
		open -e "$namenewfile"
	fi
	cd "$currentdirppc"
}

abc() {
	filetoconvertabc="$1"
	currentdirabc="$(pwd)"
	cd "$2"
	ppc "$filetoconvertabc" "$tmpdir"
	namefileconverted="$tmpdir/$namenewfile"
	
	# FLFL : There is no error messages in abc2abc ?
	abc2abc "$namefileconverted" $abcoptions > "$namenewfile"
	if [ $openfilecompile -eq 1 ] ; then
		open -e "$namefileconverted"
	else
		rm -f "$namefileconverted"
	fi
	if [ $openfile -eq 1 -a "$whatisit" = "abc" ] ; then
		open -e "$namenewfile"
	fi
	cd "$currentdirabc"
}

pst () {
	filetoconvertpst="$1"
	base="$(basename -- "$filetoconvertpst" .abc)"
	currentdirpst="$(pwd)"
	cd "$2"
	ppc "$filetoconvertpst" "$tmpdir"
	namefileconverted="$tmpdir/$namenewfile"
	
	case "$mode" in
		+)
			namenewfile=
			out="$tmpdir/sortieabcmtops$$.out"
			namenewfile=$(abcm2ps $abcoptions "$namefileconverted" $abcfileoptions 2>&1 |\
							  tee "$out" |\
							  awk '/Output written on / {print $0}' |\
							  sed -e 's/^Output written on \(.*\) (.*)$/\1/g')
			ok=$?
			echo "************************* abcm2ps messages *************************"
			cat "$out" ; rm "$out"
			echo "************************* end of abcm2ps messages *************************"
			;;
		-)
			namenewfile=
			out="$tmpdir/sortieabctops$$.out"
			namenewfile=$(abc2ps "$namefileconverted" $abcoptions 2>&1 |\
							  tee "$out" |\
							  awk '/Output written on / {print $0}' |\
							  sed -e 's/^Output written on \(.*\) (.*)$/\1/g')
			ok=$?
			echo "**************************** abc2ps messages ****************************"
			cat "$out" ; rm "$out"
			echo "************************* end of abc2ps messages *************************"
			;;
		*)
			echo "Bug interne dans la fonction pst (le mode choisi n'existe pas)" >/dev/stderr
			exit 2
			;;
	esac
	
	if [ "$namenewfile" ] ; then
		mv "$namenewfile" "$(pwd)" 2>/dev/null
		namenewfile="$(pwd)/$(basename -- "$namenewfile")"
		if [ $openfile -eq 1 -a "$whatisit" = "pst" ] ; then
			open "$namenewfile"
		fi
	fi
	if [ $openfilecompile -eq 1 -o $openonerror -eq 1 -a $ok -ne 0 ] ; then
		open -e "$namefileconverted"
	else
		rm -f "$namefileconverted"
	fi
	cd "$currentdirpst"
}

pdf () {
	filetoconvertpdf="$1"
	currentdirpdf="$(pwd)"
	cd "$2"
	pst "$filetoconvertpdf" "$tmpdir"
	if [ "$namenewfile" ] ; then
		pstopdf "$namenewfile"
		if [ $deleteps -ne 1 ] ; then
			mv "$namenewfile" "$(pwd)"
		else
			rm -f "$namenewfile"
		fi
		namenewfile="$(pwd)/$(basename -- "$namenewfile" .ps).pdf"
		if [ $openfile -eq 1 -a "$whatisit" = "pdf" ] ; then
			open "$namenewfile"
		fi
	fi
	
	cd "$currentdirpdf"
}

midi () {
	filetoconvertmid="$1"
	base="$(basename -- "$filetoconvertmid" .abc)"
	currentdirmid="$(pwd)"
	cd "$2"
	ppc "$filetoconvertmid" "$tmpdir"
	namefileconverted="$tmpdir/$namenewfile"
	
	echo "Converting file $filetoconvertmid to midi"
	echo "**************************** abc2midi warnings and errors ****************************"
	abc2midi "$namefileconverted" "$abcoptions" 2>&1 |\
	while read line ; do
#		namenewfile="$(echo $line | awk '/writing/ {print $4}')"
		namenewfile="$(echo $line | sed -e 's/writing MIDI file //g')"
#		if [ "$namenewfile" == "" ] ; then
		if [ "$namenewfile" == "$line" ] ; then
			echo $line >/dev/stderr
#			ok=0
		else
#			echo $line
			mv "$namenewfile" "$(pwd)"
			namenewfile="$(pwd)/$(basename -- "$namenewfile")"
			if [ $openfile -eq 1 -a "$whatisit" = "midi" ] ; then
				open "$namenewfile"
			fi
		fi
	done
	echo "************************* end of abc2midi warnings and errors *************************"
	
	if [ $openfilecompile -eq 1 ] ; then
		open -e "$namefileconverted"
	else
		rm -f "$namefileconverted"
	fi
	cd "$currentdirmid"
}


# global variable who can be used by other to know
# what is the name of the file created
namenewfile=

tmpdir=/tmp/
mkdir -p "$tmpdir"
while [ $# -ne 0 ] ; do
	curfile=$1
	dir="$(dirname -- "$curfile")"
	cd -- "$dir" >/dev/null 2>&1
	ok=$?
	if [ $ok -ne 0 ] ; then
		echo "No such directory named $dir" >/dev/stderr
		continue
	fi
	currentfile="$(pwd)/$(basename -- "$curfile")"
	if [ ! -f "$currentfile" ] ; then
		echo "No such file $currentfile" >/dev/stderr
	else
		$whatisit "$currentfile" "$outdir"
	fi
	shift
done
