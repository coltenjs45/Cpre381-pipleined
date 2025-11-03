.data 
result_target: .word 0 
result_ra: .word 0 
.text 
.globl main

main:
    lui  x7, 0x00400
    lui  x5, 0x10010
    lui  x6, 0x10010
    nop
    addi x7, x7, 0x28
    addi x5, x5, 0
    addi x6, x6, 0
    nop

    jalr ra, 0(x7)         # jump to target; save return address in ra
    nop

target:
    nop
    nop
    nop
    sw   t0, 0(x5)
    addi x1, x1, 0x28
    nop
    nop
    nop
    jr   ra

after_return:
    nop
    nop
    nop
    sw   ra, 0(x6)
    wfi
    

