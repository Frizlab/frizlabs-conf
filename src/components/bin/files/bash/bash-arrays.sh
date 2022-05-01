#!/bin/bash

# Either one should suffice to enter POSIX mode, but…
#  there are no arrays in POSIX mode, and this script runs fine!
export POSIXLY_CORRECT
set -o posix


# Imprime un tableau (y compris associatif).
imprime() {
	n=$((${#t[@]}-1))
	echo

	IFS='/'
	echo "t contient $((n+1)) items, d'indices ${!t[*]}"

	for i in "${!t[@]}" ; do
		echo "$i: ${t[$i]} (len(k)=${#i} len(v)=${#t[$i]})"
	done
}


# Ajoute une case à un tableau.
append () {
	t[${#t[@]}]="$1"
}


# Quelques essais.
declare -a t=(a b ccc ddddd eeeee ffffff)
imprime

t[6]="un peu plus loin"
imprime

append "encore plus loin"
imprime

unset t[4]
imprime
# Surprise : la case d'indice 4 n'existe plus (t[4] retourne '')
#  et on a bien un élément de moins dans le tableau…
# Mais il faut regarder ${!t[@]} pour savoir le(s)quel(s) manque(nt) !

t[12]="bien plus loin !"
imprime

# Variante pour l'initialisation.
t=([17]=seventeen [24]=twenty-four)
imprime

# Tableaux associatifs.
if [ $BASH_VERSINFO -ge 4 ] ; then
	unset t
	declare -A t
	t=([francois]=1990 [sylvain]=1991 [xavier]=1993 ["et les autres"]=1994)
	t[pierre]=2006
	imprime
else
	echo
	echo "Pas de tableaux associatifs en version $BASH_VERSINFO (< 4)"
fi
