all: build/npj

build/npj: src/main.asm src/io.asm src/error.asm
	fasm src/main.asm build/npj

test: .
	cd test/C && rm -rf ./* && ../../build/npj C
	cd test/CM && rm -rf ./* && ../../build/npj CM
	cd test/CB && rm -rf ./* && ../../build/npj CB
