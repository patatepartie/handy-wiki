#!/bin/sh

setupVariables() {
	REPO_SUBDIR=repo
}

installInstance() {
	mkdir $1
	git init --quiet $1/${REPO_SUBDIR}
	cd $1/${REPO_SUBDIR}
	git remote add origin $2
	exit 0
}

setupVariables
installInstance $1 $2