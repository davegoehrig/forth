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

: imm64, dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift dup $ff & b,
	8 rshift $ff & b, ;

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

: mov ( dst src -- ) 
	>r rex .w .r? b, r>
	rr? if mod11 then
	mem? if swap $8b else $89 then b, 
	modr/m ; 

: #mov ( reg imm32 - ) 
	>r rex .w .b? b, 
	rm $B8 + b, r> imm64, ;

: add  ( dst src -- )
	>r rex .w .r? b, r>  
	rr? if mod11 then
	mem? if swap 3 else 1 then b, 
	modr/m ;
	
: #add ( reg n -- )  
	>r rex .w .b? b, r>
	dup mod?
	short? if $83 else $81 then
	b, mod11 0 modr/m ;

: sub >r rex .w .r? b, r>  
	rr? if mod11 then
	mem? if swap $2b else $29 then b, 
	modr/m ;

: #sub ( reg n -- )
	>r rex .w .b? b, r>
	dup mod?
	short? if $83 else $81 then
	b, mod11 5 modr/m ;

: and ( dst src -- )
	>r rex .w .r? b, r>  
	rr? if mod11 then
	mem? if swap $23 else $21 then b, 
	modr/m ;

: #and ( reg n -- )
	>r rex .w .b? b, r>
	dup mod?
	short? if $83 else $81 then
	b, mod11 4 modr/m ;

: or ( dst src -- )
	>r rex .w .r? b, r>  
	rr? if mod11 then
	mem? if swap $0b else $09 then b, 
	modr/m ;

: #or ( reg n -- )
	>r rex .w .b? b, r>
	dup mod?
	short? if $83 else $81 then
	b, mod11 1 modr/m ;

: xor ( dst src -- )
	>r rex .w .r? b, r>  
	rr? if mod11 then
	mem? if swap $33 else $31 then b, 
	modr/m ;

: #xor ( reg n -- )
	>r rex .w .b? b, r>
	dup mod?
	short? if $83 else $81 then
	b, mod11 6 modr/m ;

: dec  ( reg - ) rex .w .b? b, $ff b, mod11 1 modr/m ;
: inc  ( reg - ) rex .w .b? b, $ff b, mod11 0 modr/m ;

: mul  ( reg - ) rex .w .b? b, $f7 b, mod11 4 modr/m ;
: imul ( reg - ) rex .w .b? b, $f7 b, mod11 5 modr/m ;
: div  ( reg - ) rex .w .b? b, $f7 b, mod11 6 modr/m ;
: idiv ( reg - ) rex .w .b? b, $f7 b, mod11 7 modr/m ;
: not  ( reg - ) rex .w .b? b, $f7 b, mod11 2 modr/m ;	
: neg  ( reg - ) rex .w .b? b, $f7 b, mod11 3 modr/m ;

: #test ( n reg - ) rex .w .r? b, $f7 b, mod11 0 modr/m imm32, ; 

: nop  ( - ) $90 b, ;
: ret  ( - ) $c3 b, ;
: syscall ( - ) $0f b, $05 b, ;
: cqo ( - ) rex .w b, $99 b, ;

create buffer  $1000 allot

: reset buffer $1000 erase buffer to 'b ;
: db buffer $10 dump ;

public

: [x86 x86_64 +order ; immediate
: x86] x86_64 -order ; immediate

end-package
