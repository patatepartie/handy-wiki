#!/bin/sh

setupVariables() {
	REPO_SUBDIR=repo
	SCRIPTS_SEPARATOR="__SCRIPTS__"
}

installInstance() {
	mkdir $1
	
	ARCHIVE=`awk '/^__SCRIPTS__/ {print NR + 1; exit 0; }' $0`
	tail -n+$ARCHIVE $0 > $1/createNewPage.sh

	git init --quiet $1/${REPO_SUBDIR}
	cd $1/${REPO_SUBDIR}
	git remote add origin $2
	exit 0
}

setupVariables
installInstance $1 $2