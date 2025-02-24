empty
include x86_64.f

: tst 
cr ." nop 90 " 
[x86 reset nop db x86]

cr ." ret c3 " 
[x86 reset ret db x86]

cr ." ret 0f 05 " 
[x86 reset syscall db x86]

cr ." cqo 48 99 " 
[x86 reset cqo db x86]

cr ." mov r15, $feedfacedeadbeef 49 bf ef be ad de ce fa  ed fe "
[x86 reset r15 $feedface $deadbeef #mov db x86]

cr ." mov rax, $feedfacedeadbeef 48 b8 ef be ad de ce fa  ed fe "
[x86 reset rax $feedface $deadbeef #mov db x86]

cr ." mov rax,rbp 48 89 e8 "
[x86 reset rax rbp mov db x86]

cr ." mov rbp,rax 48 89 c5 "
[x86 reset rbp rax mov db x86]

cr ." mov rax,[rax+0] 48 8B 40 00 "
[x86 reset rax 0 [rax] mov db x86]

cr ." mov [rax+0],rax 48 89 40 00 "
[x86 reset 0 [rax] rax mov db x86]

cr ." mov rax,[rbp-8] 48 8B 45 F8 "
[x86 reset rax -8 [rbp] mov db x86]

cr ." mov [rbp-8],rax 48 89 45 F8 "
[x86 reset -8 [rbp] rax mov db x86]

cr ." add rax,rbp 48 01 E8 "
[x86 reset rax rbp add db x86]

cr ." add rbp,rax 48 01 C5 "
[x86 reset rbp rax add db x86]

cr ." add [rbp+0],rax 48 01 45 00 "
[x86 reset 0 [rbp] rax add db x86]

cr ." add rax,[rbp+0] 48 03 45 00 "
[x86 reset rax 0 [rbp] add db x86]

cr ." push rax 50 "
[x86 reset rax push db x86]

cr ." push rdi 57 "
[x86 reset rdi push db x86]

cr ." push r8 41 50 "
[x86 reset r8 push db x86]

cr ." push r15 41 57 "
[x86 reset r15 push db x86]

cr ." pop rax 58 "
[x86 reset rax pop db x86]

cr ." pop rdi 5f "
[x86 reset rdi pop db x86]

cr ." pop r8 41 58 "
[x86 reset r8 pop db x86]

cr ." pop r15 41 5f "
[x86 reset r15 pop db x86]

cr ." inc rax 48 ff c0 "
[x86 reset rax inc db x86]

cr ." inc r15 49 ff c7 "
[x86 reset r15 inc db x86]

cr ." dec rax 48 ff c8 "
[x86 reset rax dec db x86]

cr ." dec r15 49 ff c7 "
[x86 reset r15 dec db x86]

cr ." not rax 48 f7 d0 "
[x86 reset rax not db x86]

cr ." neg rax 48 f7 d8 "
[x86 reset rax neg db x86]

cr ." imul rcx 48 f7 e9 "
[x86 reset rcx imul db x86]

cr ." idiv rcx 48 f7 f9 "
[x86 reset rcx idiv db x86]

cr ." add rax,8 48 83 C0 08 "
[x86 reset rax 8 #add db x86]

cr ." add rax,8 48 81 C0 be ba fe ca NB: sign extend! "
[x86 reset rax $cafebabe #add db x86]

cr ." sub rax,8 48 83 E8 08 "
[x86 reset rax 8 #sub db x86]

cr ." and rax,8 48 83 E0 08 "
[x86 reset rax 8 #and db x86]

cr ." or  rax,8 48 83 C8 08 "
[x86 reset rax 8 #or db x86]

cr ." xor rax,8 48 83 F0 08 "
[x86 reset rax 8 #xor db x86]

cr ." test rax,rax 48 85 C0 "
[x86 reset rax rax test db x86]

cr ." test rax,[rbp-8] 48 85 45 f8 "
[x86 reset rax -8 [rbp] test db x86]

cr ." cmp rax,[rbp-8] 48 3B 45 F8"
[x86 reset rax -8 [rbp] cmp db x86]

cr ." cmp [rbp-8],rax 48 39 45 F8"
[x86 reset -8 [rbp] rax cmp db x86]

cr ." mov rax,[r12+1023] 49 8B 84 24 23 10 "
[x86 reset rax $1023 [r12] mov db x86]

cr ." mov [r12+1023],rax 49 89 84 24 23 10"
[x86 reset $1023 [r12] rax mov db x86]

cr ." mov rax,[rsp-8] 48 8B 44 24 F8 "
[x86 reset rax -8 [rsp] mov db x86]

cr ." mov [rsp-8],rax 48 89 44 24 F8 "
[x86 reset -8 [rsp] rax mov db x86]

cr ." xchg rax,[rbp-8] 48 87 45 f8 "
[x86 reset rax -8 [rbp] xchg db x86]

cr ." mov r11, [rbp-16] "
[x86 reset r11 -16 [rbp] mov db x86]

cr ." xor rax rax "
[x86 reset rax rax xor db x86]

cr ." rax 2 #sar 48 C1 F8 02 "
[x86 reset rax 2 #sar db x86] 

cr ." rax 2 #sal 48 C1 E0 02 "
[x86 reset rax 2 #sal db x86] 

cr ." rax 2 #shr 48 C1 E8 02 "
[x86 reset rax 2 #shr db x86] 

cr ." rax 2 #shl 48 C1 E0 02 "
[x86 reset rax 2 #shl db x86] 


; tst
