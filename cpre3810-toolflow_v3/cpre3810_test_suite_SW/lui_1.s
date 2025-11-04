.data
.text
.globl main

main:

lui t0, 0x55555 #loads
nop
nop
nop

addi t1, t0, -0x1 #subtract 

wfi
