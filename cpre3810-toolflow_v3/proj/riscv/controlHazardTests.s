# RISC-V Control Hazards Test Program
# Simplified version - tests branch/jump hazards and pipeline flushing

# Built using Claude AI, edited for correctness by Graeme Anderson

# Initialize test registers
addi x1, x0, 10         # x1 = 10
addi x2, x0, 20         # x2 = 20

#================================================================
# TEST 1: BEQ taken (flush pipeline)
#================================================================
addi x3, x0, 5          # x3 = 5
addi x4, x0, 5          # x4 = 5
beq  x3, x4, taken1     # Branch taken
addi x5, x0, 99         # Should NOT execute
addi x6, x0, 99         # Should NOT execute
taken1:
addi x7, x0, 1          # x7 = 1

#================================================================
# TEST 2: BEQ not taken
#================================================================
addi x8, x0, 5          # x8 = 5
addi x9, x0, 10         # x9 = 10
beq  x8, x9, not_taken1 # Branch not taken
addi x10, x0, 2         # x10 = 2 (should execute)
not_taken1:

#================================================================
# TEST 3: BNE taken
#================================================================
addi x11, x0, 7         # x11 = 7
bne  x11, x0, taken2    # Branch taken
addi x12, x0, 99        # Should NOT execute
taken2:
addi x13, x0, 3         # x13 = 3

#================================================================
# TEST 4: BLT taken
#================================================================
addi x14, x0, 5         # x14 = 5
addi x15, x0, 10        # x15 = 10
blt  x14, x15, taken3   # Branch taken (5 < 10)
addi x16, x0, 99        # Should NOT execute
taken3:
addi x17, x0, 4         # x17 = 4

#================================================================
# TEST 5: BGE not taken
#================================================================
addi x18, x0, 5         # x18 = 5
addi x19, x0, 10        # x19 = 10
bge  x18, x19, not_taken2 # Branch not taken
addi x20, x0, 5         # x20 = 5 (should execute)
not_taken2:

#================================================================
# TEST 6: BLTU taken
#================================================================
addi x21, x0, -1        # x21 = 0xFFFFFFFF
addi x22, x0, 1         # x22 = 1
bltu x22, x21, taken4   # Branch taken (unsigned)
addi x23, x0, 99        # Should NOT execute
taken4:
addi x24, x0, 6         # x24 = 6

#================================================================
# TEST 7: BGEU taken
#================================================================
addi x25, x0, 100       # x25 = 100
addi x26, x0, 50        # x26 = 50
bgeu x25, x26, taken5   # Branch taken
addi x27, x0, 99        # Should NOT execute
taken5:
addi x28, x0, 7         # x28 = 7

#================================================================
# TEST 8: JAL (unconditional jump)
#================================================================
jal  x29, jump_target1  # Jump and link
addi x30, x0, 99        # Should NOT execute
addi x31, x0, 99        # Should NOT execute
jump_target1:
addi x1, x0, 8          # x1 = 8

#================================================================
# TEST 9: JALR (indirect jump)
#================================================================
auipc x2, 0             # x2 = PC
addi  x2, x2, 16        # x2 = PC + 16
jalr  x3, x2, 0         # Jump to x2
addi  x4, x0, 99        # Should NOT execute
addi  x5, x0, 99        # Should NOT execute
addi  x6, x0, 99        # Should NOT execute
addi  x7, x0, 9         # x7 = 9 (JALR target)

#================================================================
# TEST 10: Back-to-back branches
#================================================================
addi x8, x0, 1          # x8 = 1
addi x9, x0, 1          # x9 = 1
beq  x8, x9, taken6     # First branch taken
addi x10, x0, 99        # Should NOT execute
taken6:
addi x11, x0, 2         # x11 = 2
beq  x11, x9, not_taken3 # Second branch not taken
addi x12, x0, 10        # x12 = 10 (should execute)
not_taken3:

#================================================================
# TEST 11: Branch with forwarding to comparator
#================================================================
addi x13, x0, 5         # x13 = 5
addi x14, x13, 5        # x14 = 10 (forward from EX)
bne  x14, x0, taken7    # Branch on forwarded value
addi x15, x0, 99        # Should NOT execute
taken7:
addi x16, x0, 11        # x16 = 11

#================================================================
# TEST 12: Loop (5 iterations)
#================================================================
addi x17, x0, 0         # x17 = 0 (counter)
addi x18, x0, 5         # x18 = 5 (limit)
loop_start:
addi x17, x17, 1        # Increment
blt  x17, x18, loop_start # Loop while < 5
# x17 should be 5 after loop

#================================================================
# TEST 13: Nested branches
#================================================================
addi x19, x0, 1         # x19 = 1
beq  x19, x19, outer    # Outer branch taken
addi x20, x0, 99        # Should NOT execute
outer:
addi x21, x0, 2         # x21 = 2
bne  x21, x19, inner    # Inner branch taken
addi x22, x0, 99        # Should NOT execute
inner:
addi x23, x0, 12        # x23 = 12

#================================================================
# TEST 14: JAL forward
#================================================================
jal  x24, far_jump      # Jump far
addi x25, x0, 99        # Should NOT execute
addi x26, x0, 99        # Should NOT execute
addi x27, x0, 99        # Should NOT execute
far_jump:
addi x28, x0, 13        # x28 = 13

#================================================================
# TEST 15: Branch with ALU dependency
#================================================================
addi x29, x0, 10        # x29 = 10
addi x30, x29, 10       # x30 = 20 (forward)
beq  x30, x2, taken8    # x2 still = 20
addi x31, x0, 99        # Should NOT execute
taken8:
addi x1, x0, 14         # x1 = 14

#================================================================
# TEST 16: BGE with equal values
#================================================================
addi x2, x0, 50         # x2 = 50
addi x3, x0, 50         # x3 = 50
bge  x2, x3, taken9     # Branch taken (equal)
addi x4, x0, 99         # Should NOT execute
taken9:
addi x5, x0, 15         # x5 = 15

#================================================================
# TEST 17: BGEU with equal values
#================================================================
addi x6, x0, 100        # x6 = 100
addi x7, x0, 100        # x7 = 100
bgeu x6, x7, taken10    # Branch taken (equal)
addi x8, x0, 99         # Should NOT execute
taken10:
addi x9, x0, 16         # x9 = 16

#================================================================
# TEST 18: BLT not taken
#================================================================
addi x10, x0, 10        # x10 = 10
addi x11, x0, 5         # x11 = 5
blt  x10, x11, not_taken4 # Not taken (10 > 5)
addi x12, x0, 17        # x12 = 17 (should execute)
not_taken4:

#================================================================
# TEST 19: BNE not taken
#================================================================
addi x13, x0, 7         # x13 = 7
addi x14, x0, 7         # x14 = 7
bne  x13, x14, not_taken5 # Not taken (equal)
addi x15, x0, 18        # x15 = 18 (should execute)
not_taken5:

#================================================================
# TEST 20: Final jump to done
#================================================================
addi x16, x0, 1         # x16 = 1
beq  x16, x16, done     # Branch to done
addi x17, x0, 99        # Should NOT execute

done:
addi x18, x0, 19        # x18 = 19

# Halt
wfi
