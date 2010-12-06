#!/bin/sh

cleanUp() {
	cd ${INITIAL_DIR}
	rm -rf ${WORKING_DIR}
}

setupVariables() {
	INITIAL_DIR=${PWD}
	WORKING_DIR="/tmp/handy"
	REPO_SUBDIR="repo"
	INSTALLER="target/handy-installer.sh"
	MASTER_DIR="${WORKING_DIR}/master"
	NETBOOK_DIR="${WORKING_DIR}/netbook"
	DESKTOP_DIR="${WORKING_DIR}/desktop"
	DESKTOP_REPO="${DESKTOP_DIR}/${REPO_SUBDIR}"
	
	HOME_PAGE="HomePage"
	HOME_PAGE_CONTENT="Home Page"
}

setupWorkingDirectory() {
	mkdir ${WORKING_DIR}
}

setupMaster() {
	mkdir ${MASTER_DIR}
	git init --quiet --bare ${MASTER_DIR}
}

installInstance() {
	${INSTALLER} $1 $2
}

setupNetbook() {
	installInstance ${NETBOOK_DIR} ${MASTER_DIR}
}

setupDesktop() {
	installInstance ${DESKTOP_DIR} ${MASTER_DIR}
}

setupTraps() {
	trap cleanUp 0
	trap cleanUp 2
}

setup() {
	setupVariables	
	setupTraps	
	setupWorkingDirectory
	setupMaster
	setupNetbook
	setupDesktop
}

assertFileExists() {
	if [ ! -f $1 ] 
	then 
		quitInError "$1 does not exits"
	fi
}

assertFileContentEquals() {
	if [ "`cat ${1}`" != "$2" ]
	then
		quitInError "Content of file $1 is not $2"
	fi
}

quitInError() {
	echo $1
	announceFailure 
	exit 1
}

modifyHomePageOnNetbook() {
	cd ${NETBOOK_DIR}
	
	createNewPage "${HOME_PAGE}"
	modifyPage "${HOME_PAGE}" "${HOME_PAGE_CONTENT}"
}

createNewPage() {
	./handy-wiki.sh create "$1"
}

modifyPage() {
	./handy-wiki.sh modify "$1" "$2"
}

publishModifications() {
	./handy-wiki.sh publish
}

publishNetbookModifications() {
	cd ${NETBOOK_DIR}
	
	publishModifications
}

retreiveUpdatesOnDesktop() {
	cd ${DESKTOP_REPO}
	
	git pull --quiet origin master
}

verifyDesktopAndNetbookAreSynchronized() {
	assertFileExists ${HOME_PAGE} 
	assertFileContentEquals ${HOME_PAGE} "${HOME_PAGE_CONTENT}"
}

announceSuccess() {
	echo ---------------------------------
	echo SUCCESS
	echo ---------------------------------
}

announceFailure() {
	echo ---------------------------------
	echo FAILURE
	echo ---------------------------------
}

pageModificationsArePropagatedBetweenComputers() {
	modifyHomePageOnNetbook
	publishNetbookModifications
	retreiveUpdatesOnDesktop
	verifyDesktopAndNetbookAreSynchronized
}

setup
pageModificationsArePropagatedBetweenComputers
announceSuccess
