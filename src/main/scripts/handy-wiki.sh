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

publishModifications() {
	cd ${REPO_SUBDIR}
	git push --quiet origin master
}

setupVariables

case  "$1"  in
	"create")   createNewPage "$2";;
    "modify")   modifyPage "$2" "$3";;
    "publish")	publishModifications;;
esac
