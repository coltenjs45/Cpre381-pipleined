.data
.text
.globl main

main:
lui t0, 0xFFFFF #loads max value
nop
nop
nop

addi t1, t0, 0x1

wfi
