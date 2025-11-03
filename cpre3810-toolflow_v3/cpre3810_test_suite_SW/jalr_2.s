.data
result:
    .word 0
    
.text
.globl main

main:
    # --- Register Initialization ---
    lui x4, 0x00400 
    lui x3, 0x10010     
    li t0, 1           
    li t1, 2           
    addi x4, x4, 0x02C 
    addi x3, x3, 0x000 
    nop
    nop

    jalr ra, 0(x4)     
    nop
    addi t0, t0, -1

base_label:
    nop
    nop
    addi x4, x4, 0x28
    nop
    nop
    nop
    sw t0, 0(x3)       
    jalr ra, 0(x4)     
    nop
    addi t0, t0, -1

after_return:
    sw t1, 0(x3) 
    wfi
