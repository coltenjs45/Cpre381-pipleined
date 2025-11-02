# addi2.s - hazard free for 5-stage no forwarding
    .data
    .text
    .globl main

main:
    addi x1, x0, 2047     # x1=2047
    addi x2, x0, -2048    # x2=-2048
    nop
    nop
    nop
    # Now x1 is available
    addi x3, x1, 2047     # x3=4094 (reads x1 - safe)
    addi x5, x1, 0        # x5=2047 (reads x1 - safe)
    wfi
