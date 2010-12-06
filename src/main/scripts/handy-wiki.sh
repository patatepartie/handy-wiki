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

setupVariables

if [ "create" = "$1" ]
then
	createNewPage $2
fi 
