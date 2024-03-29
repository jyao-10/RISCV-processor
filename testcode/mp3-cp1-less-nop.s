#  mp3-cp1.s version 3.0
# modified with less nops to test hazards and data forwarding
.align 4
.section .text
.globl _start
_start:
    lw x1, %lo(NEGTWO)(x0)
    lw x2, %lo(TWO)(x0)
    lw x4, %lo(ONE)(x0)
    beq x0, x0, LOOP
    nop
    nop

.section .rodata
.balign 256
ONE:    .word 0x00000001
TWO:    .word 0x00000002
NEGTWO: .word 0xFFFFFFFE
TEMP1:  .word 0x00000001
GOOD:   .word 0x600D600D
BADD:   .word 0xBADDBADD

	
.section .text
.align 4
LOOP:
    add x3, x1, x2 # X3 <= X1 + X2
    and x5, x1, x4 # X5 <= X1 & X4
    not x6, x1     # X6 <= ~X1
    addi x9, x0, %lo(TEMP1) # X9 <= address of TEMP1
    sw x6, 0(x9)   # TEMP1 <= x6
    lw x7, %lo(TEMP1)(x0) # X7    <= TEMP1
    add x1, x1, x4 # X1    <= X1 + X4
    blt x0, x1, DONEa
    nop
    nop
    beq x0, x0, LOOP
    nop
    nop

    lw x1, %lo(BADD)(x0)
HALT:	
    beq x0, x0, HALT
    nop
    nop
		
DONEa:
    lw x1, %lo(GOOD)(x0)
DONEb:	
    beq x0, x0, DONEb
    nop
    nop
