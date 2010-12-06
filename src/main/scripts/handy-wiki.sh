#!/bin/sh

setupVariables() {
	REPO_SUBDIR=repo
}

createNewPage() {
	cd ${REPO_SUBDIR}
	touch $1
	git add $1
	git commit --quiet --message "New Page Creation"
	cd ..
}

modifyPage() {
	cd ${REPO_SUBDIR}
	
	if [ ! -f $1 ]
	then
		echo "Cannot modify file $1: it does not exist" 
		exit 1
	fi
	
	echo $2 >> $1
	git add $1
	git commit --quiet --message "A new home page"
	cd ..
}

setupVariables

if [ "create" = "$1" ]
then
	createNewPage "$2"
else
	modifyPage "$2" "$3"
fi 
