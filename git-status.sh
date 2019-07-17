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
  -d		Gived detailed listing of files that are not committed. \n
  -h		show this help info (for MOTD)\n
\n
- ${green}Green${textreset} means no uncommited changes -- you're good. \n
- ${yellow}Yellow${textreset} means staged but not committed changes.\n
- ${red}Red${textreset} means changes exist, nut no staged changes yet.\n
- ${blue}Blue${textreset} means not a git repo.\n
"
# Check if shell is launched with parameter "-c"
if [[ "$@" == *'-h'*  ]] || [[ "$@" == *'--help'*  ]]; then
	echo -e $help
	exit
fi

if [[ "$@" == *'-d'*  ]]; then
	DETAILED=True
	# Removes the "-d", and sends the
	checkdirs=${@/-d/}
else
	DETAILED=False
	checkdirs=$@
fi

if [ "$checkdirs" == "" ]; then
	checkdirs=(.)
fi

for checkdir in $checkdirs ; do
	for dir in `ls $checkdir` ; do
		if [ ! -d "$checkdir/$dir/.git" ] ; then
			echo "${blue}NO git $checkdir/$dir${textreset}"
		else
			cd "$checkdir/$dir"
			lines=`git status --porcelain`
			if [ ${#lines[@]} -lt 2 -a "$lines" == "" ] ; then
				echo "${green}Clean  $dir${textreset}"
			else
				echo "${red}Dirty  $dir${textreset}"

				if [[ $DETAILED == "True" ]]; then
				for l in $lines ; do
					if [ ${#l} -lt 3 ] ; then
						printf %s "$l "
					else
						echo $l
					fi
				done
				fi
			fi
			cd ..
		fi
	done
done
