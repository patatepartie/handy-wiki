#!/bin/sh

setupVariables() {
	INITAL_DIR=${PWD}
	WORKING_DIR=/tmp/handy
	MASTER_DIR=${WORKING_DIR}/master
	NETBOOK_DIR=${WORKING_DIR}/netbook
	DESKTOP_DIR=${WORKING_DIR}/desktop
	
	HOME_PAGE=HomePage
	HOME_PAGE_CONTENT="Home Page"
}

cleanUp() {
	cd ${INITIAL_DIR}
	rm -rf ${WORKING_DIR}
}

setupWorkingDirectory() {
	mkdir ${WORKING_DIR}
}

setupMaster() {
	mkdir ${MASTER_DIR}
	git init --bare ${MASTER_DIR}
}

setupNetbook() {
	git init ${NETBOOK_DIR}
	cd ${NETBOOK_DIR}
	git remote add origin ${MASTER_DIR}
	
}

setupDesktop() {
	git init ${DESKTOP_DIR}
	cd ${DESKTOP_DIR}
	git remote add origin ${MASTER_DIR}
}

setup() {
	setupVariables	
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

main() {
	cd ${NETBOOK_DIR}
	echo ${HOME_PAGE_CONTENT} > ${HOME_PAGE}
	git add ${HOME_PAGE}
	git commit -m "A new home page"
	
	git push origin master
	
	cd ${DESKTOP_DIR}
	git pull origin master
	
	assertFileExists ${HOME_PAGE} 
	assertFileContentEquals ${HOME_PAGE} "${HOME_PAGE_CONTENT}" 
}

trap cleanUp 0
trap cleanUp 2

setup
main