# addi1.s - hazard free for 5-stage no forwarding
    .data
    .text
    .globl main

main:
    addi x1, x0, 15       # x1=15
    addi x2, x0, -10      # x2=-10
    nop
    nop
    nop
    # Now x1 is available
    addi x3, x1, 5        # x3=20 (reads x1 - safe)
    addi x4, x1, -5       # x4=10 (reads x1 - safe)
    addi x0, x1, 100      # attempt to write x0 (reads x1 - safe)
    wfi
