all : test

test : test.asm
	nasm test.asm
	hexdump -C test
	cat test.asm
