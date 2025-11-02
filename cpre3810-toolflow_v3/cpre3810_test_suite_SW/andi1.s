# andi1.s - hazard free for 5-stage no forwarding
# All pseudo-instructions manually expanded
    .data
result:
    .word 0

    .text
    .globl main

main:
    # li t0, 0xF0F0 manually expanded:
    lui  t0, 0xF             # t0 = 0x0000F000
    nop
    nop
    nop
    addi t0, t0, 0x0F0        # t0 = 0x0000F0F0 (reads t0 - safe)
    nop
    nop
    nop
    
    lui  t2, 0x10010         # t2 = 0x10010000 (after LUI)
    nop                      # Stall 1
    nop                      # Stall 2
    nop                      # Stall 3
    addi t2, t2, 0x000       # t2 = 0x10010000 (Address of 'result' is finalized)    nop                       # This assumes RARS expands 'la' into auipc/addi
    
    nop
    nop                       # You may need to adjust the number of NOPs here
    nop                       # based on the expansion and pipeline needs.
    
    # Now t0 is available with final value
    andi t1, t0, 0x00FF       # t1 = 0x000000F0 (reads t0 - safe)
    nop
    nop
    nop
    nop
    # Now t1 is available
    sw   t1, 0(t2)            # Store result (reads t1 - safe)
    wfi