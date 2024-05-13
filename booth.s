.data 
md: .word 567874
mr: .word 676543
result: .word 0,0,0,0

.text
.global _start
_start:
@loading the values of md and mr in registers r2 and r3 respectively
ldr r2,=md 
ldr r3,=mr
ldr r2,[r2]
ldr r3,[r3]

@for taking bitwise-AND of mr with 00000001 in binary
mov r4,#1
@for changing msb of V (r0) if required
mov r7,#0x80000000

@booth's algorithm procedure

mov r0,r3 		@ mr in V(r0)
mov r1,#0 		@ 0 in U(r1)
mov r6,#0		@ prev bit initialised with 0,stored in r6

mov r8,#0 	@ i == 0 start i++ till i==32

loop:		@loop start
cmp r8,#32
beq end
add r8,r8,#1

@ current(last) bit stored in r5
and r5,r4,r0 @ r4 contians 1 r0 is V
										
@check (current bit,prev bit)
cmp r5,r6	
beq rightshift

cmp r5,r6
bgt OZ @(1,0)

ZO: @(0,1)
add r1,r1,r2
b rightshift

OZ: @(1,0)
sub r1,r1,r2

@ else prevbit = currbit case
rightshift:
and r9,r4,r1
mov r0,r0,LSR #1
cmp r9,#1
bne skip

orr r0,r0,r7	@ msb of V = 1 if lsb of U was 1 b4 shifting

skip:
mov r6,r5		@ curr bit <- prev bit
mov r1,r1,ASR #1

b loop			@loop1 end

end: 
ldr r10,=result
str r1,[r10]
str r0,[r10,#4]
smull r11,r12,r2,r3 @check r11->lower
str r12,[r10,#8]
str r11,[r10,#12]
stop: b stop
