dgforth
-------

the time has come, the time is now - Dr. Seuss 

playing around with LLMs for work all day long has lead me to the belief that the only
way we're ever going to create robot overlords is to teach them to program in Forth.

getting started
---------------

to start with we're going to implement an x86_64.f assembler to allow us to write a
brand new forth from scratch.  our platform of choice for doing this will be [SwiftForth](https://www.forth.com/swiftforth/) because it is an awesome $400 cross platform 32 bit 
forth that let us experiment and write our own in a way we can bootstrap eventually.

register assignments
--------------------

registers are going to be assigned based on
the x86_64 Linux kernel ABI so that we don't
have to juggle too many parameters when making
system calls.  additionally, we'll natively
support string operations and only store a
basic set of system variables in registers for
convience. for the data stack we'll keep the
top value in [ebp-8] so ebp points at free 
data stack making our ds0 calculation easier.

╔════════════════════╦════════════════════╗
║ rax -- tos         ║ r8  -- arg5        ║
║ rcx -- count       ║ r9  -- arg6        ║
║ rdx -- arg3        ║ r10 -- arg4        ║
║ rbx -- org         ║ r11 -- tmp         ║
║ rbx -- org         ║ r11 -- tmp         ║
║ rsp -- rsp         ║ r12 -- .data       ║
║ rbp -- dsp         ║ r13 -- D           ║
║ rsi -- src, arg2   ║ r14 -- H           ║
║ rdi -- dst, arg1   ║ r15 -- last        ║
╚════════════════════╩════════════════════╝


memory layout
-------------

our memory layout is going to be fixed to start:

╔═════════════════════════════════════════╗ < rbx 
║ x86_64 preamble, jump to boot           ║
╠════════════════════╦════════════════════╣
║ last (r15)         ║ h      (r14)       ║
╠════════════════════╬════════════════════╣
║ d    (r13)         ║ .data  (r12)       ║
╠════════════════════╩════════════════════╣
║ dictionary ...  (320k)                  ║ < r15 ↓
╠═════════════════════════════════════════╣
║ code ...  (2MB)                         ║ < r14 ↓
╠═════════════════════════════════════════╣ < r12  
║ data ...  (2MB)                         ║ < r13 ↓
╠═════════════════════════════════════════╣ 
║ data stack (16k)                        ║ < rbp ↑
║ return stack (16k)                      ║ < rsp ↑ 
╚═════════════════════════════════════════╝

we'll start with 16 byte preamble that does
a call 0, pop rbx, sub rbx,5 to get the base
address in memory and store it in rbx. then
we'll compile a jump to the word BOOT which
will handle loading the current dictionary
value (last, r15), current free code pointer
(H, r14), current free data heap pointer (D, r13)
and the data segement base ( .data, r12 ).

eventually we might break out .code.system
and .code.user and .data.system and .data.user
and .dict.system and .dict.user but that will
only be after we add mprotect and mseal support.

regi
