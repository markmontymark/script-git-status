#!/bin/bash

## green means no uncommited changes
## yellow means staged but not committed changes
## red means no staged changes
## blue means not a git repo

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

checkdirs=$@
if [ "$checkdirs" == "" ]; then
	checkdirs=(.)
fi

for checkdir in $checkdirs ; do
	for dir in `ls $checkdir` ; do
		if [ ! -d "$checkdir/$dir/.git" ] ; then
			echo "${blue}$checkdir/$dir${textreset}"
		else
			cd "$checkdir/$dir"
			lines=`git status --porcelain`
			if [ ${#lines[@]} -lt 2 -a "$lines" == "" ] ; then
				echo "${green}$dir${textreset}"
			else
				echo "${red}$dir${textreset}"
				for l in $lines ; do
					if [ ${#l} -lt 3 ] ; then
						printf "$l "
					else
						echo $l
					fi
				done
			fi
			cd ..
		fi
	done
done
