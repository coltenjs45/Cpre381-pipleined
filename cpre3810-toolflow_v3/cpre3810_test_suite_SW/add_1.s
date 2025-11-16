.data
    .text
    .globl main
main:
    # Load all immediate values first
    addi x2, x0, 7        # x2=7 (available after 3 instructions)
    addi x4, x0, -3       # x4=-3 (available after 3 instructions)
    
    # Now x2 and x4 are available from WB stage
    add x3, x2, x0        # x3=7+0=7 (reads x2 - safe)
    add x5, x4, x2        # x5=(-3)+7=4 (reads x4, x2 - safe)
    add x6, x2, x4        # x6=7+(-3)=4 (reads x2, x4 - safe)
    
    wfi