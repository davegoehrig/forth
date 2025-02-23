\ x86_64.f
\ --------
\ This is a minimal x86_64 assembler

package x86_64

: ~ not ;
: & and ;
: | or ;
: ^ xor ;

: rex  $40 ;
: .w $08 | ;	\ 1 64bit operand, 0 default
: .r $04 | ;	\ reg extension
: .x $02 | ;	\ sib index extension
: .b $01 | ;	\ mod r/m extension

: rm  7 & ;
: reg rm 3 lshift ;

0 value 'b

: b, 'b c! 'b 1 + to 'b ;

: imm8, b, ;

: imm16, dup $ff & b, 8 rshift b, ;

: imm32, dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift $ff & b, ;

: imm64, imm32, imm32, ; 

: short? -80 80 within ;
: long? short? ~ ;

0 value mod
0 value sib
0 value disp
0 value imm8?
0 value imm32?
0 value imm64?

\ reset the
: nexti 0 to mod 0 to sib 0 to disp 0 to imm8? 0 to imm32? 0 to imm64? ;

: r15 $f ;
: r14 $e ;
: r13 $d ;
: r12 $c ;
: r11 $b ;
: r10 $a ;
: r9  9 ;
: r8  8 ;
: rdi 7 ;
: rsi 6 ;
: rbp 5 ;
: rsp 4 ;
: rbx 3 ;
: rdx 2 ;
: rcx 1 ;
: rax 0 ;

: mod00 0   to mod ;
: mod01 $40 to mod ;
: mod10 $80 to mod ;
: mod11 $C0 to mod ;

: imm8 ( n -- ) mod01 1 to imm8? to disp ;
: imm32 ( n -- ) mod10 1 to imm32? to disp ;

: mod? ( offset - ) dup short? if imm8 else imm32 then ;
: mem $80 | ;
: mem? dup $80 & ;
: rr? over $80 & over $80 & | ~ ;

: [rax] ( offset -- rm ) mod? rax mem ;
: [rbx] ( offset -- rm ) mod? rbx mem ;
: [rbp] ( offset -- rm ) mod? rbp mem ;
: [rsp] ( offset -- rm ) mod? rsp mem ;
: [r12] ( offset -- rm ) mod? r12 mem ;
: [r13] ( offset -- rm ) mod? r13 mem ;
: [r15] ( offset -- rm ) mod? r15 mem ;

: .b? over 8 & if .b then ;
: .r? over 8 & if .r then ;

: modr/m ( rm reg -- ) 
	reg swap rm | mod | b, 
	imm8? if disp imm8, then
	imm32? if disp imm32, then 
	nexti ;

: call  ( rm - ) $ff b, 2 modr/m ;

: #call ( imm32 - ) $e8 imm32, ;
: #jmp  ( imm32 - ) $e9 imm32, ;

: #js  ( imm32 - ) $0f b, $88 b, imm32, ;
: #jns ( imm32 - ) $0f b, $89 b, imm32, ;
: #jz  ( imm32 - ) $0f b, $84 b, imm32, ;
: #jnz ( imm32 - ) $0f b, $85 b, imm32, ;
: #jge ( imm32 - ) $0f b, $8d b, imm32, ;
: #jg  ( imm32 - ) $0f b, $8f b, imm32, ;
: #jle ( imm32 - ) $0f b, $8e b, imm32, ;
: #jl  ( imm32 - ) $0f b, $8c b, imm32, ;

0 value op1 
0 value op2
: alu2 ( dst src op1 op2 -- )
	to op2 to op1
	>r rex .w .r? b, r>
	rr? if mod11 then
	mem? if swap op1 else op2 then b, 
	modr/m ; 

0 value op3
: #alu2 ( reg n op1 op2 op3 -- )
	to op3 to op2 to op1
	>r rex .w .b? b, r>
	dup mod?
	short? if op1 else op2 then
	b, mod11 op3 modr/m ;

: alu1 ( reg f -- ) to op1 to op2 rex .w .b? b, op2 b, mod11 op1 modr/m ;

: mov ( dst src -- ) $8b $89 alu2 ;

: #mov ( reg imm32 imm32 - ) 
	>r >r rex .w .b? b, 
	rm $B8 + b, r> r> imm64, ;

: add  ( dst src -- )   3   1 alu2 ;
: sub  ( dst src -- ) $2b $29 alu2 ;
: and  ( dst src -- ) $23 $21 alu2 ;
: or   ( dst src -- ) $0b $09 alu2 ;
: xor  ( dst src -- ) $33 $31 alu2 ;
: test ( dst src -- ) $85 $85 alu2 ;
: cmp  ( dst src -- ) $3b $39 alu2 ;

: #add ( reg n -- ) $83 $81 0 #alu2 ;
: #or  ( reg n -- ) $83 $81 1 #alu2 ;
: #and ( reg n -- ) $83 $81 4 #alu2 ;
: #sub ( reg n -- ) $83 $81 5 #alu2 ;
: #xor ( reg n -- ) $83 $81 6 #alu2 ;

: inc  ( reg - ) $ff 0 alu1 ;
: dec  ( reg - ) $ff 1 alu1 ;
: not  ( reg - ) $f7 2 alu1 ;	
: neg  ( reg - ) $f7 3 alu1 ;
: mul  ( reg - ) $f7 4 alu1 ;
: imul ( reg - ) $f7 5 alu1 ;
: div  ( reg - ) $f7 6 alu1 ;
: idiv ( reg - ) $f7 7 alu1 ;

: push ( reg - ) dup 8 & if rex .b b, then rm $50 + b, ;
: pop  ( reg - ) dup 8 & if rex .b b, then rm $58 + b, ;

: #test ( n reg - ) rex .w .r? b, $f7 b, mod11 0 modr/m imm32, ; 

: nop     ( - ) $90 b, ;
: ret     ( - ) $c3 b, ;
: syscall ( - ) $0f b, $05 b, ;
: cqo     ( - ) rex .w b, $99 b, ;


create buffer  $1000 allot
: reset buffer $1000 erase buffer to 'b ;
: db buffer $10 dump ;

public

: [x86 x86_64 +order ; immediate
: x86] x86_64 -order ; immediate

end-package
