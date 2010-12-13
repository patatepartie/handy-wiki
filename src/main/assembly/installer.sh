#!/bin/sh

setupVariables() {
	REPO_SUBDIR="repo"
	APPLICATION="handy-wiki.sh"
}

createInstanceDirectory() {
	mkdir $1
}

extractApplicationScript() {
	SCRIPT_LINE=`awk '/^__HANDY_WIKI__/ {print NR + 1; exit 0; }' $0`
	BINARIES=`tail -n+$SCRIPT_LINE $0`
	echo "$BINARIES" > $1/${APPLICATION}
	chmod +x $1/${APPLICATION}
}

createInstanceRepository() {
	git init --quiet $1/${REPO_SUBDIR}
}

linkInstanceRepositoryToMaster() {
	cd $1/${REPO_SUBDIR}
	git remote add origin $2
}

installInstance() {
	createInstanceDirectory $1	
	extractApplicationScript $1
	createInstanceRepository $1
	linkInstanceRepositoryToMaster $1 $2
}

setupVariables
installInstance $1 $2
exit 0
