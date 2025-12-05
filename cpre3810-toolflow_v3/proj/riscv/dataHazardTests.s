# RISC-V Data Hazards and Forwarding Test Program
# Simplified version - tests core forwarding scenarios

# Built using Claude AI, edited for correctness by Graeme Anderson

# Initialize base registers
addi x1, x0, 100        # x1 = 100
addi x2, x0, 200        # x2 = 200

#================================================================
# TEST 1: EX-to-EX Forwarding (RAW hazard with 1 cycle distance)
#================================================================
addi x3, x0, 5          # x3 = 5
add  x4, x3, x1         # x4 = 105 (needs forwarding from EX)
sub  x5, x4, x2         # x5 = -95 (needs forwarding from EX)

#================================================================
# TEST 2: MEM-to-EX Forwarding (RAW hazard with 2 cycle distance)
#================================================================
addi x6, x0, 15         # x6 = 15
addi x7, x0, 25         # x7 = 25
add  x8, x6, x7         # x8 = 40 (needs forwarding from MEM for x6)

#================================================================
# TEST 3: Chain of dependencies
#================================================================
addi x9, x0, 7          # x9 = 7
slli x10, x9, 2         # x10 = 28 (forward from EX)
add  x11, x10, x9       # x11 = 35 (forward x10 from EX, x9 from MEM)
sub  x12, x11, x10      # x12 = 7 (forward x11 from EX, x10 from MEM)

#================================================================
# TEST 4: Register file bypass (WB-to-ID forwarding)
#================================================================
addi x13, x0, 77        # x13 = 77
addi x14, x0, 88        # x14 = 88
addi x15, x0, 99        # x15 = 99
add  x16, x13, x14      # x16 = 165 (bypass WB values)

#================================================================
# TEST 5: Back-to-back ALU operations
#================================================================
addi x17, x0, 1         # x17 = 1
addi x18, x17, 1        # x18 = 2 (forward from EX)
addi x19, x18, 1        # x19 = 3 (forward from EX)
addi x20, x19, 1        # x20 = 4 (forward from EX)
addi x21, x20, 1        # x21 = 5 (forward from EX)

#================================================================
# TEST 6: Shift operations with forwarding
#================================================================
addi x22, x0, 8         # x22 = 8
slli x23, x22, 3        # x23 = 64 (forward from EX)
srli x24, x23, 2        # x24 = 16 (forward from EX)
srai x25, x24, 1        # x25 = 8 (forward from EX)

#================================================================
# TEST 7: Logical operations
#================================================================
addi x26, x0, 0xFF      # x26 = 255
andi x27, x26, 0x0F     # x27 = 15 (forward from EX)
ori  x28, x27, 0xF0     # x28 = 255 (forward from EX)
xori x29, x28, 0xFF     # x29 = 0 (forward from EX)

#================================================================
# TEST 8: Set less than operations
#================================================================
addi x30, x0, 100       # x30 = 100
addi x31, x0, 50        # x31 = 50
slt  x1, x31, x30       # x1 = 1 (forward from EX)
slti x2, x1, 2          # x2 = 1 (forward from EX)

#================================================================
# TEST 9: Multiple uses of same register
#================================================================
addi x3, x0, 10         # x3 = 10
add  x4, x3, x3         # x4 = 20 (forward x3 twice from EX)
sub  x5, x4, x3         # x5 = 10 (forward x4 from EX, x3 from MEM)

#================================================================
# TEST 10: LUI and AUIPC with forwarding
#================================================================
lui  x6, 0x12345        # x6 = 0x12345000
addi x7, x6, 0x678      # x7 = 0x12345678 (forward from EX)
auipc x8, 0             # x8 = PC
addi x9, x8, 4          # x9 = PC+4 (forward from EX)

#================================================================
# TEST 11: Complex dependency pattern
#================================================================
addi x10, x0, 5         # x10 = 5
add  x11, x10, x10      # x11 = 10 (forward from EX)
add  x12, x11, x10      # x12 = 15 (forward x11 from EX, x10 from MEM)
add  x13, x12, x11      # x13 = 25 (forward x12 from EX, x11 from MEM)

#================================================================
# TEST 12: XOR with itself (zero result)
#================================================================
addi x14, x0, 0xAA      # x14 = 0xAA
xor  x15, x14, x14      # x15 = 0 (forward from EX twice)
xori x16, x15, 0xFF     # x16 = 0xFF (forward from EX)

#================================================================
# TEST 13: OR and AND combinations
#================================================================
addi x17, x0, 0x0F      # x17 = 0x0F
addi x18, x0, 0xF0      # x18 = 0xF0
or   x19, x17, x18      # x19 = 0xFF (forward from EX)
and  x20, x19, x17      # x20 = 0x0F (forward x19 from EX, x17 from MEM)

#================================================================
# TEST 14: Subtraction chain
#================================================================
addi x21, x0, 100       # x21 = 100
addi x22, x0, 30        # x22 = 30
sub  x23, x21, x22      # x23 = 70 (forward from EX)
sub  x24, x23, x22      # x24 = 40 (forward x23 from EX, x22 from MEM)

#================================================================
# TEST 15: Triple dependency
#================================================================
addi x25, x0, 3         # x25 = 3
add  x26, x25, x25      # x26 = 6 (forward from EX)
add  x27, x26, x25      # x27 = 9 (forward from EX and MEM)
add  x28, x27, x26      # x28 = 15 (forward from EX and MEM)

# Halt
wfi
