#Written using Google Gemini, configured to fit our constraints

.data
data_word: .word 0

.text
.globl main
main:
    # --- SETUP ---
    la      x19, data_word
    addi    x31, x0, 0
    
    addi    x1, x0, 10
    addi    x2, x0, 20
    addi    x3, x0, 10
    addi    x4, x0, 5

#================================================================
# TEST 1: Simple Branch Taken
#================================================================
    beq     x1, x3, taken1
    addi    x31, x31, 99
taken1:
    addi    x31, x31, 1

#================================================================
# TEST 2: Simple Branch Not Taken
#================================================================
    beq     x1, x2, skip_not_taken
    addi    x31, x31, 2
skip_not_taken:

#================================================================
# TEST 3: JAL (Unconditional Jump/Flush)
#================================================================
    jal     x5, jump_target
    addi    x31, x31, 99
jump_target:
    addi    x31, x31, 4

#================================================================
# TEST 4: Branch Dependency - Forwarding to Comparator
#================================================================
    addi    x6, x4, 5
    beq     x6, x1, taken4
    addi    x31, x31, 99
taken4:
    addi    x31, x31, 8

#================================================================
# TEST 5: Load-Branch (Consecutive) - 2-cycle stall likely
#================================================================
    addi    x7, x0, 10
    sw      x7, 0(x19)
    lw      x8, 0(x19)
    beq     x8, x7, taken5
    addi    x31, x31, 99
taken5:
    addi    x31, x31, 16

#================================================================
# TEST 6: Load-Instruction-Branch (1-cycle stall likely)
#================================================================
    addi    x9, x0, 5
    sw      x9, 0(x19)
    lw      x10, 0(x19)
    addi    x11, x0, 5
    beq     x10, x11, taken6
    addi    x31, x31, 99
taken6:
    addi    x31, x31, 32

#================================================================
# TEST 7: Load-Instruction-Instruction-Branch (0 stall)
#================================================================
    addi    x12, x0, 25
    sw      x12, 0(x19)
    lw      x13, 0(x19)
    addi    x14, x0, 10
    addi    x15, x0, 10
    bne     x13, x14, taken7
    addi    x31, x31, 99
taken7:
    addi    x31, x31, 64

#================================================================
# TEST 8: Loop Control Hazard (BLT taken/not taken repeatedly)
#================================================================
    addi    x16, x0, 0
    addi    x17, x0, 5
loop_start:
    addi    x16, x16, 1
    blt     x16, x17, loop_start
    
    beq     x16, x17, loop_pass
    addi    x31, x31, 99
    j       halt
loop_pass:
    addi    x31, x31, 128

# --- Halt ---
halt:
    li      a7, 10
    wfi