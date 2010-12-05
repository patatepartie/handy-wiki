#!/bin/sh

setupVariables() {
	SCRIPTS_SEPARATOR="__SCRIPTS__"
	INSTALLER="src/main/assembly/installer.sh"
	PAGE_CREATION_SCRIPT="src/main/scripts/createNewPage.sh"
	FULL_INSTALLER="target/handy-installer.sh"
}

package() {
	cat ${INSTALLER} > ${FULL_INSTALLER}
	echo "\n\n${SCRIPTS_SEPARATOR}" >> ${FULL_INSTALLER}
	cat ${PAGE_CREATION_SCRIPT} >> ${FULL_INSTALLER}
	chmod +x ${FULL_INSTALLER}
}

setupVariables
package