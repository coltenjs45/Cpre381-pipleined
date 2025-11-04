.data
.text
.globl main

main:
addi t0, x0, 0x1 # sets t0 to 0x00000001
nop
nop
nop

lui t0, 0x98765 #loads value over the above

wfi
