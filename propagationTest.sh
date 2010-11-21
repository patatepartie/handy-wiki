#!/bin/sh

cleanUp() {
	cd ${INITIAL_DIR}
	rm -rf ${WORKING_DIR}
}

setupVariables() {
	INITAL_DIR=${PWD}
	WORKING_DIR=/tmp/handy
	REPO_SUBDIR=repo
	MASTER_DIR=${WORKING_DIR}/master
	NETBOOK_DIR=${WORKING_DIR}/netbook
	NETBOOK_REPO=${NETBOOK_DIR}/${REPO_SUBDIR}
	DESKTOP_DIR=${WORKING_DIR}/desktop
	DESKTOP_REPO=${DESKTOP_DIR}/${REPO_SUBDIR}
	
	HOME_PAGE=HomePage
	HOME_PAGE_CONTENT="Home Page"
}

setupWorkingDirectory() {
	mkdir ${WORKING_DIR}
}

setupMaster() {
	mkdir ${MASTER_DIR}
	git init --quiet --bare ${MASTER_DIR}
}

setupNetbook() {
	mkdir ${NETBOOK_DIR}
	git init --quiet ${NETBOOK_REPO}
	cd ${NETBOOK_REPO}
	git remote add origin ${MASTER_DIR}
}

setupDesktop() {
	mkdir ${DESKTOP_DIR}
	git init --quiet ${DESKTOP_REPO}
	cd ${DESKTOP_REPO}
	git remote add origin ${MASTER_DIR}
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
		echo "$1 does not exits"
		exit 1
	fi
}

assertFileContentEquals() {
	if [ "`cat ${1}`" != "$2" ]
	then
		echo Content of file $1 is not $2
		exit 1
	fi
}

modifyHomePageOnNetbook() {
	cd ${NETBOOK_REPO}
	echo ${HOME_PAGE_CONTENT} > ${HOME_PAGE}
	git add ${HOME_PAGE}
	git commit --quiet --message "A new home page"
}

publishNetbookModifications() {
	git push --quiet origin master
}

retreiveUpdatesOnDesktop() {
	cd ${DESKTOP_REPO}
	git pull --quiet origin master
}

verifyDesktopAndNetbookAreSynchronized() {
	assertFileExists ${HOME_PAGE} 
	assertFileContentEquals ${HOME_PAGE} "${HOME_PAGE_CONTENT}"
}

pageModificationsArePropagatedBetweenComputers() {
	modifyHomePageOnNetbook
	publishNetbookModifications
	retreiveUpdatesOnDesktop
	verifyDesktopAndNetbookAreSynchronized
}

setup
pageModificationsArePropagatedBetweenComputers