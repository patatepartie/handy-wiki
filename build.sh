#!/bin/sh

setupVariables() {
	TEST_SCRIPTS_DIR="src/test/scripts"
}

build() {
	./package.sh
	./${TEST_SCRIPTS_DIR}/propagationTest.sh
}

setupVariables
build