# andi2.s - hazard free for 5-stage no forwarding
# All pseudo-instructions manually expanded
    .data
result:
    .word 0

    .text
    .globl main

main:
    # li t0, 0x1234567F manually expanded:
    lui  t0, 0x12346       # t0 = 0x12346000
    nop                    # Independent instruction
    nop
    nop
    # Now t0 is available
    addi t0, t0, 0x67F     # t0 = 0x1234567F (reads t0 - safe)  
    nop
    nop
    nop
    
    lui  t2, 0x10010         # t2 = 0x10010000 (after LUI)
    nop                      # Stall 1
    nop                      # Stall 2
    nop                      # Stall 3
    addi t2, t2, 0x000       # t2 = 0x10010000 (Address of 'result' is finalized)    nop                       # This assumes RARS expands 'la' into auipc/addi
    nop
    nop
    nop
    
    # Now t0 is available with final value
    andi t1, t0, -16       # t1 = 0x12345670 (reads t0 - safe)
    nop
    nop
    nop
    # Now t1 is available
    sw   t1, 0(t2)         # Store (reads t1 - safe)
    wfi
