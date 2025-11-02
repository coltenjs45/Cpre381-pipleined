# addi_02.s - hazard free for 5-stage no forwarding
    .option norvc
    .text
    .globl main
main:
    addi x1, x0, 123      # x1=123
    addi x3, x0, -1       # x3=-1
    addi x4, x0, -2048    # x4=-2048
    
    addi x8, x0, 2047     # x8=2047
    addi x9, x0, 2046     # x9=2046
    addi x10, x0, 0       # x10=0
    
    nop
    nop
    nop
    # Now x1, x3, x4 are available
    addi x0, x1, 1        # attempt write to x0 (reads x1 - safe)
    addi x2, x0, 0        # x2=0
    addi x5, x3, 1        # x5=0 (reads x3 - safe)
    
    addi x6, x4, 2047     # x6=-1 (reads x4 - safe)
    addi x7, x3, 2047     # x7=2046 (reads x3 - safe)
    nop
    
    nop
    nop
    nop
    # Now x9 is available
    addi x9, x9, 1        # x9=2047 (reads x9 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x9 is available
    addi x9, x9, 1        # x9=2048 (reads x9 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x10, x10, 100    # x10=100 (reads x10 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x10, x10, -50    # x10=50 (reads x10 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x10, x10, -50    # x10=0 (reads x10 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x11, x10, 0      # x11=0 (reads x10 - safe)
    addi x0, x0, 0        # NOP
    
    wfi
