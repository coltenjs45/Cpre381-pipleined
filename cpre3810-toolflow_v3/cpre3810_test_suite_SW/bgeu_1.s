.data

.text
.globl main

main:

# Load Registers
    addi x1, x0, 100        # li x1, 100 (Single instruction)
    addi x2, x0, 100        # li x2, 100 (Single instruction)
    addi t0, x0, 0          # li t0, 0 (Counter, Writes t0)
    
    # 3 NOPs to resolve data hazard on t0 before any potential read (though far away)
    nop 
    nop
    nop

# --- Test 1: rs1 = rs2 (100 >= 100) - VALID (Branch TAKEN) ---
    bgeu x1, x2, test1_target
    nop                     # Control Hazard Delay Slot (1 NOP for ID resolution)
    # The instruction below will be skipped if the branch is TAKEN
    addi t0, t0, 1          # NOT TAKEN counter increment
    
test1_target:
    addi x1, x1, 1          # x1 = 101 (Writes x1)
    
    # 3 NOPs to resolve data hazard on x1 before next bgeu (Reads x1)
    nop
    nop
    nop

# --- Test 2: rs1 > rs2 (101 >= 100) - VALID (Branch TAKEN) ---
    bgeu x1, x2, test2_target
    nop                     # Control Hazard Delay Slot
    addi t0, t0, 1          # NOT TAKEN counter increment
    
test2_target:
    addi x2, x2, 2          # x2 = 102 (Writes x2)
    
    # 3 NOPs to resolve data hazard on x2 before next bgeu (Reads x2)
    nop
    nop
    nop

# --- Test 3: rs1 < rs2 (101 < 102) - NOT VALID (Branch NOT TAKEN) ---
    bgeu x1, x2, test3_target
    nop                     # Control Hazard Delay Slot
    addi t0, t0, 1          # NOT TAKEN counter increment (t0 = 1)
    
test3_target:

# --- Test 4 Setup: signed difference - VALID (-1 > 102 Unsigned) ---
    # Manually expanded: li x1, -1 (0xFFFFFFFF)
    lui x1, 0xFFFFF         # Writes x1 (High 20 bits)
    nop                     # Stall 1
    nop                     # Stall 2
    nop                     # Stall 3
    addi x1, x1, -1         # Writes x1 (Final value 0xFFFFFFFF)
    
    # 3 NOPs to resolve data hazard on x1 before next bgeu (Reads x1)
    nop
    nop
    nop

# --- Test 4: rs1 > rs2 (0xFFFFFFFF >= 102) - VALID (Branch TAKEN) ---
    bgeu x1, x2, test4_target
    nop                     # Control Hazard Delay Slot
    addi t0, t0, 1          # NOT TAKEN counter increment
    
test4_target:

# --- Test 5 Setup: signed difference - NOT VALID (100 < -1 Unsigned) ---
    addi x1, x0, 100        # li x1, 100 (Writes x1)
    
    # 3 NOPs to resolve data hazard on x1 before next li x2 (which reads x1) - Not needed, but safe
    nop
    nop
    nop
    
    # Manually expanded: li x2, -1 (0xFFFFFFFF)
    lui x2, 0xFFFFF         # Writes x2
    nop                     # Stall 1
    nop                     # Stall 2
    nop                     # Stall 3
    addi x2, x2, -1         # Writes x2 (Final value 0xFFFFFFFF)
    
    # 3 NOPs to resolve data hazard on x2 before next bgeu (Reads x2)
    nop
    nop
    nop

# --- Test 5: rs1 < rs2 (100 < 0xFFFFFFFF) - NOT VALID (Branch NOT TAKEN) ---
    bgeu x1, x2, test5_target
    nop                     # Control Hazard Delay Slot
    addi t0, t0, 1          # NOT TAKEN counter increment (t0 = 2)
    
test5_target:

# --- Test 6 Setup: max unsigned value equality - VALID (4095 = 4095) ---
    addi x1, x0, -1       # li x1, 4095 (Writes x1)
    addi x2, x0, -1       # li x2, 4095 (Writes x2)
    
    # 3 NOPs to resolve data hazards on x1 and x2 before next bgeu (Reads x1/x2)
    nop
    nop
    nop

# --- Test 6: rs1 = rs2 (4095 >= 4095) - VALID (Branch TAKEN) ---
    bgeu x1, x2, test7_target
    nop                     # Control Hazard Delay Slot
    addi t0, t0, 1          # NOT TAKEN counter increment
    
test7_target:

# --- Test 7 Setup: 0 vs max unsigned value equality - NOT VALID (0 < 4095) ---
    addi x1, x0, 0          # li x1, 0 (Writes x1)
    
    # 3 NOPs to resolve data hazard on x1 before next bgeu (Reads x1)
    nop
    nop
    nop

# --- Test 7: rs1 < rs2 (0 < 4095) - NOT VALID (Branch NOT TAKEN) ---
    bgeu x1, x2, end
    nop                     # Control Hazard Delay Slot
    addi t0, t0, 1          # NOT TAKEN counter increment (t0 = 3)

end:
    wfi
