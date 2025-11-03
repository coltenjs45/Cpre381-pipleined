    .data
result:
    .word 0

    .text
    .globl main

main:
    li t0, 0
    li t1, 1
    li x1, -5
    li x2, 3
    lui x3, 0x10010   
    nop               
    nop               
    nop               
    addi x3, x3, 0x000

    blt  x1, x2, less
    nop
    sw   t0, 0(x3)
    j    done

less:
    sw   t1, 0(x3)

done:
    wfi

