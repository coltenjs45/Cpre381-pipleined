# andi3.s - hazard free for 5-stage no forwarding
# All pseudo-instructions manually expanded
    .data
result_zero:
    .word 0
result_id:
    .word 0
result_x0:
    .word 0

    .text
    .globl main

main:
    # Case A: andi with immediate 0
    # li t0, 0xDEADBEEF manually expanded:
    lui  t0, 0xDEADC      # t0 = 0xDEADC000
    nop                   # Independent instruction
    nop
    nop
    # Now t0 is available
    addi t0, t0, -273     # t0 = 0xDEADBEEF (0xBEEF = -273 in 12-bit signed)    
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
    andi t1, t0, 0        # t1 = 0 (reads t0 - safe)
    nop
    nop
    nop
    # Now t1 is available
    sw   t1, 0(t2)        # Store (reads t1 - safe)

    # Case B: andi with -1
    # li t0, 0xCAFEBABE manually expanded:
    lui  t0, 0xCAFEB      # t0 = 0xCAFEB000
    nop                   # Independent instruction
    nop
    nop
    # Now t0 is available
    addi t0, t0, -1346    # t0 = 0xCAFEBABE (0xABE = -1346 in 12-bit signed)
    nop
    nop
    nop

    lui  t2, 0x10010         # t2 = 0x10010000 (after LUI)
    nop                      # Stall 1
    nop                      # Stall 2
    nop                      # Stall 3
    addi t2, t2, 0x004       # t2 = 0x10010000 (Address of 'result' is finalized)    nop                       # This assumes RARS expands 'la' into auipc/addi
    nop
    nop
    nop

    # Now t0 is available with final value
    andi t1, t0, -1       # t1 = t0 (reads t0 - safe)
    nop
    nop
    nop
    # Now t1 is available
    sw   t1, 0(t2)        # Store (reads t1 - safe)

    # Case C: andi with x0
    andi t3, x0, 0x7FF    # t3 = 0 (no hazard, reads x0)
    nop
    nop
    nop

    lui  t2, 0x10010         # t2 = 0x10010000 (after LUI)
    nop                      # Stall 1
    nop                      # Stall 2
    nop                      # Stall 3
    addi t2, t2, 0x008       # t2 = 0x10010000 (Address of 'result' is finalized)    nop                       # This assumes RARS expands 'la' into auipc/addi
    nop
    nop
    nop

    # Now t3 is available
    sw   t3, 0(t2)        # Store (reads t3 - safe)
    
    wfi
