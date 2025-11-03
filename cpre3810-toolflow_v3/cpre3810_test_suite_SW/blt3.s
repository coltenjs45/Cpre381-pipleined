    .data
result_equal:
    .word 0
result_greater:
    .word 0

    .text
    .globl main

main:
    lui t5, 0x10010
    lui t6, 0x10010 
    li  t0, 7
    li  t1, 7
    li  t3, 12
    li  t4, 5
    li  a0, 0
    li  a1, 1
    addi t5, t5, 0x000       
    nop      
    addi t6, t6, 0x004 
    nop

# Test 3A: Equal operands → no branch
    blt  t0, t1, less_equal
    nop
    sw   a0, 0(t5)
    j    next_test
    nop

less_equal:
    sw   a1, 0(t5)

next_test:
# Test 3B: t3 > t4 → no branch
    blt  t3, t4, less_greater
    nop
    sw   a0, 0(t6)
    j    done

less_greater:
    sw   a1, 0(t6)

done:
    wfi

