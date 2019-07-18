#!/bin/bash

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

help="Usage: git-status.sh [-d/-h/--help] [DIR]\n
Example: 'git-status.sh -d'\n
\n
Options:\n
${red}  -d, --detailed${textreset} 		Gived detailed listing of files that are not committed. \n
${red}  -h, --help${textreset}		show this help info (for MOTD)\n
\n
- ${green}Green${textreset} means no uncommited changes -- you're good. \n
- ${yellow}Yellow${textreset} means staged but not committed changes.\n
- ${red}Red${textreset} means changes exist, nut no staged changes yet.\n
- ${blue}Blue${textreset} means not a git repo.\n

Only folder are analysed, files are skipped.
"
# Check if shell is launched with parameter "-c"
if [[ "$@" == *'-h'*  ]] || [[ "$@" == *'--help'*  ]]; then
	echo -e $help
	exit
fi

if [[ "$@" == *'-d'*  ]] ; then
	DETAILED=True
	# Removes the "-d", and sends the
	checkdirs=${@/-d/}
elif [[ "$@" == *'--detailed'* ]]; then
	DETAILED=True
	# Removes the "-d", and sends the
	checkdirs=${@/--detailed/}
else
	DETAILED=False
	checkdirs=$@
fi

if [ "$checkdirs" == "" ]; then
	checkdirs=(.)
		PWD1=""

fi

for checkdir in $checkdirs ; do
	cd $checkdir
	if [[ ! $PWD1 == "" ]]; then
			PWD1=$(pwd)/
	fi

	for dir in `find  *  -maxdepth 0 -type d` ; do
		if [[ ! -d "$dir/.git" ]] ; then
			echo "${blue}NO git $PWD1$dir${textreset}"
		else
			cd "$checkdir/$dir"
			dirtyC=$(git status --porcelain | wc -l)
				if [ $dirtyC == 0 ] ; then
					echo "${green}Clean  $PWD1$dir${textreset}"
				else
					echo "${red}Dirty  $PWD1$dir${textreset} $dirtyC files dirty"

					## runs if detailed level is set.
					if [[ $DETAILED == "True" ]]; then
						git status -s
						echo
					fi

				fi
			cd ..
		fi
		done
done
