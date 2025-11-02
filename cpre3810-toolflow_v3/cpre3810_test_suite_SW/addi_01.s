# addi_01.s - hazard free for 5-stage no forwarding
.data
.text
.option norvc
.globl main
main:
    addi x1, x0, 0        # x1=0
    addi x2, x0, 0        # x2=0
    addi x3, x0, 2047     # x3=2047
    
    addi x4, x0, -2048    # x4=-2048
    addi x6, x0, -1       # x6=-1
    addi x8, x0, 1        # x8=1
    
    nop
    nop
    nop
    # Now x3, x6, x8 are available
    addi x5, x3, -2047    # x5=0 (reads x3 - safe)
    addi x7, x6, 1        # x7=0 (reads x6 - safe)
    addi x9, x8, -2       # x9=-1 (reads x8 - safe)
    
    addi x10, x0, 1000    # x10=1000
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x10, x10, 47     # x10=1047 (reads x10 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x10, x10, -1047  # x10=0 (reads x10 - safe)
    nop
    nop
    
    nop
    nop
    nop
    # Now x10 is available
    addi x11, x10, 0      # x11=0 (reads x10 - safe)
    addi x0, x0, 0        # NOP
    
    wfi