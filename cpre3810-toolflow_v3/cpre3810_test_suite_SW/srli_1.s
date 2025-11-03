.data

.text
.globl main

main:

    # Start Test

    lui x5, 0xFFFFF 
    nop
    nop
    nop
    srli x5, x5, 4  # 0x0FFFFF00
    nop
    nop
    nop
    srli x5, x5, 4  # 0x00FFFFF0 
    nop
    nop
    nop
    srli x5, x5, 4  # 0x000FFFFF
    nop
    nop
    nop
    srli x5, x5, 4  # 0x0000FFFF
    nop
    nop
    nop
    srli x5, x5, 4  # 0x00000FFF
    nop
    nop
    nop
    srli x5, x5, 4  # 0x000000FF
    nop
    nop
    nop
    srli x5, x5, 4  # 0x0000000F
    nop
    nop
    nop
    srli x5, x5, 4 # register x1 should now be empty (0x00000000) - testing basic functionality
 
    wfi               

