#!/bin/sh

setupVariables() {
	TEST_SCRIPTS_DIR="src/test/scripts"
}

package() {
	./package.sh
}

endToEndTests() {
	./${TEST_SCRIPTS_DIR}/propagationTest.sh
}

build() {
	package
	endToEndTests	
}

setupVariables
build
