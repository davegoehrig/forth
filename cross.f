\ cross.f
\ a simple cross compiler so that we can use a 32 bit system to compile our 64 bit one

package cross-compiler

\ ╔════════════════════╦═══╦═══════════════════╗
\ ║ xt | -xt           ║ L ║ word... 23 chars  ║
\ ╚════════════════════╩═══╩═══════════════════╝

: def 
	\ define a word in  the target dictionary
	\ should set the xt to the offset from ebx
	\ to the location in the code segment if 
	\ should set the xt to negative if the word
	\ is an immediate word.
;
	


public

end-package
