\ core.f
\ x86_64 forth core words

include cross.f
include x86_64.f

def c! ( c a -- ) [x86 
	rdi rax mov 		\ set dst
	rax -8 [rbp] mov 	\ nos -> tos
	$88 b, $07 b, 		\ mov [rdi],al
	rax -16 [rbp] mov	\ drop 
	rbp 16 #sub 		\ drop
	ret
x86]

def c@ ( a - c ) [x86
	rsi rax mov		\ set src
	rax rax xor		\ clear rax
	$8a b, $06 b,		\ mov al, [rsi]
	ret
x86]
	
def ! ( n a -- ) [x86 
	rdi rax mov		\ set dst
	rax -8 [rbp] mov	\ load tos
	0 [rdi] rax mov		\ store tos
	rax -16 [rbp] mov	\ drop
	rbp 16 #sub		\ drop
	ret
x86] 

def @ ( a -- n ) [x86
	rsi rax mov		\ set src
	rax [rsi] mov		\ and fetch
	ret
x86]

def !+ ( a n -- a2 ) [x86
	rdi -8 [rbp] mov	\ load nos to dst
	[rdi] rax mov		\ store to dst
	rdi 8 #add		\ advance pointer
	rax rdi mov		\ mov a2 to tos
	rbp 8 #sub 		\ nip
	ret
x86]

def @+ ( a -- a2 n ) [x86
	rbp 8 #add		\ dup
	rsi rax mov		\ set src
	rax [rsi] mov		\ fetch
	rsi 8 #add		\ make addr2
	-8 [rbp] rsi mov	\ to nos
	ret
x86]

def , ( n -- ) [x86
	mov [r14], rax		\ store n
	r14 8 #add		\ advance H  
	rax -8 [rbp] mov	\ drop
	rbp 8 #sub
	ret
x86]

def c, ( c -- ) [x86
	$41 b, 88 b, 6 b, 	\ mov [r14],al
	r14 1 #add		\ advance H
	rax -8 [rbp] mov	\ drop
	rbp 8 #sub
	ret
x86]

def +! ( n addr -- ) [x86
	rdx -8 [rbp] mov	\ load rdx
	0 [rax] rdx add		\ add rds to addr
	rbp -16 #add		\ 2 drop
	rax 0 [rbp] mov		\ pop
	ret
x86]

def on ( addr -- ) [x86
	0 [rax] -1 #mov		\ store -1 in addr
	rax -8 [rbp] mov	\ drop
	rbp 8 #sub		\ 
	ret
x86]

def off ( addr -- ) [x86
	0 [rax] 0 #mov		\ store 0 in addr
	rax -8 [rbp] mov	\ drop
	rbp 8 #sub		\ 
	ret
x86]

def r> ( -- x) ( r: x -- ) [x86
	rbp 8 #add		\ dup
	-8 [rbp] rax mov
	rax pop			\ pop rs
	ret
x86]

def >r ( x -- ) ( r: -- x ) [x86
	rax push		\ push tos
	rax -8 [rbp] mov	\ drop
	rbp 8 #sub
	ret
x86]

def r@ ( -- x ) ( r: x -- x ) [x86
	rbp 8 #add		\ dup 
	-8 [rbp] rax mov	\ save tos
	rax 0 [rsp] mov		\ fetch rtos
	ret
x86]

def +rp ( n -- ) [x86
	rsp rax add		\ add tos to rsp
	rax -8 [rbp] mov	\ drop
	rbp 8 #sub
	ret
x86]

def nip ( x1 x2 -- x2 ) [x86
	rbp 8 #sub
	ret
x86]

def drop ( x -- ) [x86
	rax -8 [rbp] mov
	rbp 8 #sub
	ret
x86]

def dup ( x -- x x ) [x86
	rbp 8 #add
	-8 [rbp] rax mov
	ret
x86]

def swap ( x1 x2 -- x2 x1 ) [x86
	rax -8 [rbp] xchg
	ret
x86]	

def over ( x1 x2 -- x1 x2 x1 ) [x86
	rbp 8 #add		\ dup
	-8 [rbp] rax mov
	rax -16 [rbp] mov	\ load
	ret
x86]

def 3rd ( x1 x2 x3 -- x1 x2 x3 x1 ) [x86
	rbp 8 #add
	-8 [rbp] rax mov
	rax -24 [rbp] mov
	ret
x86]

def 4th ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 ) [x86
	rbp 8 #add
	-8 [rbp] rax mov
	rax -32 [rbp] mov
	ret
x86]

def rot ( x1 x2 x3 -- x2 x3 x1 ) [x86
	-8 [rbp] rax xchg
	-16 [rbp] rax xchg
	ret
x86]

def -rot ( x1 x2 x3 -- x3 x1 x2 ) [x86
	-16 [rbp] rax xchg
	-8 [rbp] rax xchg
	ret
x86]

def tuck ( x1 x2 -- x1 x2 x1 ) [x86
	rdx -8 [rbp] mov	\ copy x1
	rbp 8 #add		\ dup tos
	-8 [rbp] rax mov
	rax rdx mov		\ set tos x1
	ret
x86]

def ?dup ( x -- 0 | x x ) [x86
	rax rax or 8 #jz
	rbp 8 #add
	-8 [rbp] rax mov
	ret
x86]

def and ( x1 x2 -- x3 ) [x86
	rax -8 [rbp] and
	rbp 8 #sub
	ret
x86]

def or ( x1 x2 -- x3 ) [x86
	rax -8 [rbp] or
	rbp 8 #sub
	ret
x86]

def xor ( x1 x2 -- x3 ) [x86
	rax -8 [rbp] xor
	rbp 8 #sub
	ret
x86]

def invert ( x1 -- x2 ) [x86
	rax not
	ret
x86]

def + ( x1 x2 -- x3 ) [x86
	rax -8 [rbp] add
	rbp 8 #sub
	ret
x86]

def - ( x1 x2 -- x3 ) [x86
	rax neg
	rax -8 [rbp] add
	rbp 8 #sub
	ret
x86]

def swap- ( x1 x2 -- x3 ) [x86
	rax -8 [rbp] sub
	rbp 8 #sub
	ret
x86]

def negate ( n -- -n ) [x86
	rax neg
	ret
x86]

def abs ( n -- +n ) [x86
	rax rax test 3 #js
	rax neg
	ret
x86]

def >< ( x -- x ) [x86
	$86 b, $c4 b, 	\ xchg al,ah
	ret
x86]

def < ( a b -- f ) [x86
	rdx rax mov
	rax rax rax
	-8 [rbp] rdx cmp
	3 #jge rax not
	rbp 8 #sub
	ret
x86]

def > ( a b -- f ) [x86
	rdx rax mov
	rax rax rax
	-8 [rbp] rdx cmp
	3 #jle rax not
	rbp 8 #sub
	ret
x86]

def = ( a b -- f ) [x86
	rdx rax mov
	rax rax rax
	-8 [rbp] rdx cmp
	3 #jne rax not
	rbp 8 #sub
	ret
x86]
	
def <= ( a b -- f ) [x86
	rdx rax mov
	rax rax rax
	-8 [rbp] rdx cmp
	3 #jg rax not
	rbp 8 #sub
	ret
x86]
	
def >= ( a b -- f ) [x86
	rdx rax mov
	rax rax rax
	-8 [rbp] rdx cmp
	3 #jl rax not
	rbp 8 #sub
	ret
x86]

def <0 ( x -- f ) [x86
	cqo
	rax rdx mov
	ret
x86] 

def 0> ( x -- f ) [x86
	rdx rax mov
	rax rax xor
	rdx 0 cmp
	3 #jg rax not
	ret
x86]	

def 0= ( x -- f ) [x86
	rdx rax mov
	rax rax xor
	rdx rdx test
	3 #jnz rax not
	ret
x86]

def min ( n1 n2 -- n3 ) [x86
	rdx -8 [rbp] mov
	rbp 8 #sub
	rdx rax cmp
	3 #jg rax rdx mov
	ret
x86]

def max ( n1 n2 -- n3 ) [x86
	rdx -8 [rbp] mov
	rbp 8 #sub
	rdx rax cmp
	3 #jl rax rdx mov
	ret
x86]

def within ( n lo hi -- f ) [x86
	r11 -16 [rbp] mov 	\ n
	rcx -8 [rbp] mov 	\ lo
	rdx rax mov 		\ hi
	rax rax xor 		\ zero rax
	r11 rcx cmp		\ n - lo 
	12 #jl
	r11 rdx cmp		\ n - hi 3 bytes 
	3 #jg			\ 6 bytes
	rax not			\ 3 bytes
	ret
x86]

def 1+ ( n -- n+1 ) [x86
	rax inc
	ret
x86]

def 1- ( n -- n-1) [x86
	rax dec
	ret
x86]

def 2+ ( n -- n+2 ) [x86
	rax 2 #add
	ret
x86]

def 2- ( n -- n-2 ) [x86
	rax 2 #sub
	ret
x86]

def 2/ ( n -- n-2 ) [x86
	rax 2 #sar
	ret
x86]

def 2* ( n --  n*2 ) [x86
	rax 2 #shl
	ret
x86]

def u2/ ( u -- u/2 ) [x86
	rax 2 #shr
	ret
x86]

def 4+ ( n -- n+4 ) [x86
	rax 4 #add
	ret
x86]

def 4- ( n -- n+4 ) [x86
	rax 4 #sub
	ret
x86]

def 8+ ( n -- n+4 ) [x86
	rax 8 #add
	ret
x86]

def 8- ( n -- n+4 ) [x86
	rax 8 #sub
	ret
x86]

def lshift ( x n -- x2 ) [x86
	ecx rax mov
	rax -8 [rbp] mov
	$48 b, $d3 b, $e0 b,	\ shl rax,cl
	[rbp] 8 #sub
	ret
x86] 

def rshift ( x n -- x2 ) [x86
	ecx rax mov
	rax -8 [rbp] mov
	$48 b, $d3 b, $e8 b,	\ shl rax,cl
	[rbp] 8 #sub
	ret
x86] 

def lshifta ( x n -- x2 ) [x86
	ecx rax mov
	rax -8 [rbp] mov
	$48 b, $d3 b, $e0 b,	\ shl rax,cl
	[rbp] 8 #sub
	ret
x86] 

def rshifta ( x n -- x2 ) [x86
	ecx rax mov
	rax -8 [rbp] mov
	$48 b, $d3 b, $f8 b,	\ shl rax,cl
	[rbp] 8 #sub
	ret
x86] 

def cell ( -- n ) [x86
	rbp 8 #add
	-8 [rbp] rax mov
	rax 8 #mov
	ret
x86]

def -cell ( -- n ) [x86
	rbp 8 #add
	-8 [rbp] rax mov
	rax -8 #mov
	ret
x86]

def cell+ ( n -- n2 ) [x86
	rax 8 #add
	ret
x86]

def cell- ( n -- n2 ) [x86
	rax -8 #add
	ret
x86]

def cells ( n -- n*8 ) [x86
	rax 3 #shl
	ret
x86]

def cell/ ( n -- n/8 ) [x86
	rax 3 #shr
	ret
x86]

def char+ ( n -- n+1 ) [x86
	rax inc
	ret
x86]

\ x86_64 is byte aligned
def chars ( n -- n ) [x86 ret x86]
def aligned ( addr -- addr ) [x86 ret x86]
def align ( -- ) [x86 ret x86]

def unloop ( -- ) [x86
	rsp -16 #add
	ret
end


\ TODO figure out what the actual return stack layout will be for loops
def i ( -- n ) [x86
	ebp 8 #add
	-8 [ebp] rax mov
	rax 0 [rsp] mov
	ret
x86]

\ TODO figure out what the actual return stack layout will be for loops
def j ( -- n )  [x86
	ebp 8 #add
	-8 [ebp] rax mov
	rax -16 [rsp] mov
	ret
x86]


