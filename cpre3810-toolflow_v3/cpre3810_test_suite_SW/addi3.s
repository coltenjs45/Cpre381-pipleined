# addi3.s - hazard free for 5-stage no forwarding
    .data
    .text
    .globl main

main:
    addi x1, x0, 100      # x1=100
    addi x2, x0, 1        # x2=1
    addi x6, x0, 1000     # x6=1000
    
    nop
    nop
    nop
    # Now x1, x2, x6 are available
    addi x1, x1, 50       # x1=150 (reads x1 - safe)
    addi x3, x2, 1        # x3=2 (reads x2 - safe)
    addi x6, x6, 1000     # x6=2000 (reads x6 - safe)
    
    nop
    nop
    nop
    # Now new values are available
    addi x4, x3, 1        # x4=3 (reads x3 - safe)
    addi x6, x6, -200     # x6=1800 (reads x6 - safe)
    nop
    
    nop
    nop
    nop
    # Now x4 is available
    addi x5, x4, 1        # x5=4 (reads x4 - safe)
    
    wfi
