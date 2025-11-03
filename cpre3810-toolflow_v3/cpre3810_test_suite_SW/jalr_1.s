.data

.text
.globl main

main:
    # --- Address Setup (Calculates Jump Target Address) ---
    lui x4, 0x00400  
    nop
    nop
    nop
    addi x4, x4, 0x028
    nop
    nop
    nop

    # --- Jump and Link ---
    jalr ra, 8(x4)   
    nop

after_return:
    nop
    addi x5, x0, 1   
    j terminate                     
    
target:
    # --- Function/Target (Target Address: 0x00400030) ---
    nop                
    addi x6, x0, 99        
    jr ra                 
    nop

terminate:
    wfi