# and_2.s - hazard free for 5-stage no forwarding
.data
.text
.globl main

main:
    lui x1, 1044496       # Set upper bits
    lui x2, -16           # Set upper bits
    nop
    nop
    nop
    # Now x1 is available
    addi x1, x1, -256     # x1=0xFF00FF00 (reads x1 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x1 and x2 are available
    and x3, x1, x2        # x3=0xFF000000 (reads x1, x2 - safe)
    
    wfi
