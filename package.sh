#!/bin/sh

setupVariables() {
	SCRIPTS_SEPARATOR="__HANDY_WIKI__"
	INSTALLER="src/main/assembly/installer.sh"
	SCRIPTS_DIR="src/main/scripts"
	PAGE_CREATION_SCRIPT="${SCRIPTS_DIR}/handy-wiki.sh"
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